# Git Aliases & Functions
alias g="git"

# Status & Log
alias gs="git status"
alias gl="git log --oneline --graph --decorate -n 15"
alias gll="git log --oneline --graph --decorate"
alias gd="git diff"
alias gds="git diff --staged"

# Branching
alias gb="git branch"
alias gba="git branch -a"
alias gco="git checkout"
alias gcb="git checkout -b"
alias gbd="git branch -d"
alias gbD="git branch -D"

# Commit & Push
alias ga="git add"
alias gaa="git add --all"
alias gc="git commit -m"
alias gca="git commit --amend"
alias gp="git push"
alias gpf="git push --force-with-lease"
alias gpl="git pull"

# Stash
alias gst="git stash"
alias gstp="git stash pop"
alias gstl="git stash list"

# GitHub integration
# Open current repo in browser
alias ghub="gh repo view --web"

# Open PR for current branch
alias gpr="gh pr view --web"

# Create new PR with args and open web UI after
mkpr() {
  local current_branch=$(git rev-parse --abbrev-ref HEAD)
  
  # If on main/master, prompt for a new branch name
  if [[ "$current_branch" == "main" || "$current_branch" == "master" ]]; then
    echo "Current branch is $current_branch. You should not PR from $current_branch."
    echo -n "Enter name for new branch: "
    read new_branch
    if [[ -z "$new_branch" ]]; then
      echo "Branch name cannot be empty. Aborting."
      return 1
    fi
    git checkout -b "$new_branch"
    current_branch="$new_branch"
  fi

  # Check if there are unpushed commits
  if ! git rev-parse --quiet --verify "origin/$current_branch" >/dev/null 2>&1; then
    echo "Branch not found on remote. Pushing $current_branch to origin..."
    git push -u origin "$current_branch"
  fi

  # If no args, use gemini or claude to generate title and body
  if [[ $# -eq 0 ]]; then
    local ai_cmd=""
    if command -v gemini >/dev/null 2>&1; then
      ai_cmd="gemini"
    elif command -v claude >/dev/null 2>&1; then
      ai_cmd="claude"
    else
      echo "Neither 'gemini' nor 'claude' found. Please provide PR title and body manually."
      return 1
    fi

    echo "Generating PR title and description using $ai_cmd..."
    # Get diff of current branch against main
    local main_branch=$(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@' || echo "main")
    local diff_content=$(git diff "origin/$main_branch...$current_branch")
    
    if [[ -z "$diff_content" ]]; then
       echo "No changes detected between $current_branch and $main_branch. Aborting."
       return 1
    fi

    # Use AI to generate the PR details
    local pr_info=$(echo "$diff_content" | $ai_cmd "Generate a concise GitHub PR title and a bulleted description for these changes. Output in the format: TITLE: <title> BODY: <body>")
    
    local title=$(echo "$pr_info" | grep -oP 'TITLE: \K.*(?= BODY:)' || echo "$pr_info" | head -n 1)
    local body=$(echo "$pr_info" | grep -oP 'BODY: \K.*' || echo "$pr_info" | tail -n +2)
    
    gh pr create --title "$title" --body "$body" && gh pr view --web
  else
    # Use provided args
    gh pr create "$@" && gh pr view --web
  fi
}

# Helper Functions
# Undo last commit but keep changes
alias gundo="git reset --soft HEAD~1"

# Sync with main/master
gsync() {
  local main_branch=$(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@' || echo "main")
  echo "Syncing with $main_branch..."
  git fetch origin
  git rebase "origin/$main_branch"
}

# Clean up local branches that are merged into main
gbclean() {
  local main_branch=$(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@' || echo "main")
  git branch --merged "$main_branch" | grep -v "\*" | grep -v "$main_branch" | xargs -n 1 git branch -d
}
