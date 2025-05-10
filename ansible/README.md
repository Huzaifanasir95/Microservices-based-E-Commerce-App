# Ansible Deployment for Online Boutique

This directory contains Ansible configuration to deploy the Online Boutique microservices application to a local Kubernetes cluster (Docker Desktop).

## Prerequisites

- Ansible installed on your local machine
- Docker Desktop with Kubernetes enabled
- kubectl configured to work with your local Kubernetes cluster
- Python modules: kubernetes, openshift (for Ansible k8s module)

## Installation of Dependencies

```bash
# Install Ansible
pip install ansible

# Install required Python modules for Kubernetes
pip install kubernetes openshift

# Install Ansible Kubernetes collections
ansible-galaxy collection install kubernetes.core
```

## Usage

To deploy the Online Boutique application to your local Kubernetes cluster:

```bash
# Navigate to the ansible directory
cd ansible

# Run the deployment playbook
ansible-playbook -i inventories/hosts deploy-local.yml
```

## Configuration

The deployment can be customized by modifying the variables in `roles/kubernetes/defaults/main.yml`:

- `kubernetes_namespace`: The namespace to deploy the application to
- `kube_context`: The Kubernetes context to use (default: docker-desktop)
- `ingress_host`: The hostname for the ingress (default: onlineboutique.com)
- `argocd_enabled`: Whether to deploy ArgoCD (default: true)

## What the Playbook Does

1. Verifies that Kubernetes is running
2. Sets the Kubernetes context to Docker Desktop
3. Creates necessary namespaces
4. Deploys NGINX Ingress Controller (if not already installed)
5. Deploys service accounts
6. Deploys all microservices from the k8s directory
7. Configures ingress
8. Deploys ArgoCD (if enabled)
9. Displays service information and application URL