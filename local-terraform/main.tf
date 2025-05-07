terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.23"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.10"
    }
  }
  required_version = ">= 1.0.0"
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "docker-desktop"
}

provider "helm" {
  kubernetes {
    config_path    = "~/.kube/config"
    config_context = "docker-desktop"
  }
}

# Create namespace for our application
resource "kubernetes_namespace" "shop_microservices" {
  metadata {
    name = "shop-microservices"
    labels = {
      environment = var.environment
    }
  }
}

# Create namespace for ArgoCD
resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
    labels = {
      environment = var.environment
    }
  }
}

# Deploy ArgoCD using Helm chart
resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "5.46.7"
  namespace  = kubernetes_namespace.argocd.metadata[0].name

  set {
    name  = "server.service.type"
    value = "NodePort"
  }
  
  set {
    name  = "server.service.nodePortHttp"
    value = "30081"  # ArgoCD UI accessible on port 30081
  }
}