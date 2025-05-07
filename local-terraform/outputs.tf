output "kubernetes_context" {
  description = "Kubernetes context for local deployment"
  value       = "docker-desktop"
}

output "argocd_url" {
  description = "URL to access ArgoCD UI"
  value       = "http://localhost:30081"
}

output "frontend_url" {
  description = "URL to access the Online Boutique frontend"
  value       = "http://localhost:30080"
}