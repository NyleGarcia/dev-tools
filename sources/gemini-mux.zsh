# Alias for the multiplexer
alias gmux="gemini-mux"

# Quick start alias
alias gm-start="gemini-mux start"
alias gm-yolo="gemini-mux start --yolo"

# Quick stop alias
alias gm-stop="gemini-mux stop"

# Function to add current workstream to the session
# Usage: gm-add "my-task" "feat-branch" "work description"
gm-add() {
  gemini-mux add "$@"
}

gm-add-yolo() {
  gemini-mux add "$1" "$2" "$3" --yolo
}
