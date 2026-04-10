# Kubernetes Aliases & Functions
alias k="kubectl"

# Context & Namespace management
alias kc="kubectl config"
alias kcx="kubectl config use-context"
alias kn="kubectl config set-context --current --namespace"

# Viewing Resources
alias kg="kubectl get"
alias kgp="kubectl get pods"
alias kgs="kubectl get services"
alias kgd="kubectl get deployments"
alias kgi="kubectl get ingress"
alias kgn="kubectl get nodes"
alias kga="kubectl get all"

# Describe & Edit
alias kd="kubectl describe"
alias kdp="kubectl describe pod"
alias kds="kubectl describe service"
alias kdd="kubectl describe deployment"
alias ke="kubectl edit"

# Logs & Execution
alias kl="kubectl logs"
alias klf="kubectl logs -f"
alias kex="kubectl exec -it"

# Resource Deletion (Use with caution)
alias krm="kubectl delete"

# Helper Functions
# Get pods for a specific label: kgl app=my-app
kgl() {
  kubectl get pods -l "$1"
}

# Watch pods: kwp
alias kwp="watch kubectl get pods"

# Describe latest pod in namespace
kdlast() {
  local pod=$(kubectl get pods --sort-by=.metadata.creationTimestamp --no-headers | tail -n1 | awk '{print $1}')
  echo "Describing pod: $pod"
  kubectl describe pod "$pod"
}
