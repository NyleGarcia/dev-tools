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

# Helper Functions
# Undo last commit but keep changes
alias gundo="git reset --soft HEAD~1"

# Sync with main/master
gsync() {
  local main_branch=$(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@')
  echo "Syncing with $main_branch..."
  git fetch origin
  git rebase "origin/$main_branch"
}

# Clean up local branches that are merged into main
gbclean() {
  local main_branch=$(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@')
  git branch --merged "$main_branch" | grep -v "\*" | grep -v "$main_branch" | xargs -n 1 git branch -d
}
