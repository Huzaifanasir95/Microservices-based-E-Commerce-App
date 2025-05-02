#!/bin/bash
# Script to set up a local Kubernetes cluster and configure it for the Online Boutique microservices

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

echo -e "${GREEN}Online Boutique Local Kubernetes Setup${NC}"
echo "This script will help you set up a local Kubernetes cluster for development."
echo ""

# Check for required tools
echo -e "${YELLOW}Checking prerequisites...${NC}"

if ! command_exists docker; then
    echo -e "${RED}Error: Docker is not installed. Please install Docker first.${NC}"
    echo "Visit https://docs.docker.com/get-docker/ for installation instructions."
    exit 1
fi

# Check if Kubernetes is available - either through Docker Desktop, Minikube, or Kind
CLUSTER_TYPE=""

if command_exists kubectl; then
    echo -e "${GREEN}✓ kubectl is installed${NC}"
    
    # Check if kubectl can connect to a cluster
    if kubectl cluster-info &>/dev/null; then
        echo -e "${GREEN}✓ kubectl is connected to a Kubernetes cluster${NC}"
        echo -e "Current context: $(kubectl config current-context)"
        CLUSTER_TYPE="existing"
    else
        echo -e "${YELLOW}kubectl is installed but not connected to a cluster.${NC}"
    fi
else
    echo -e "${RED}Error: kubectl is not installed. Please install kubectl first.${NC}"
    echo "Visit https://kubernetes.io/docs/tasks/tools/ for installation instructions."
    exit 1
fi

# If no existing cluster, determine which tool to use
if [ "$CLUSTER_TYPE" != "existing" ]; then
    echo -e "${YELLOW}No existing Kubernetes cluster detected. Checking available options...${NC}"
    
    if command_exists minikube; then
        echo -e "${GREEN}✓ Minikube is installed${NC}"
        read -p "Do you want to create a Kubernetes cluster using Minikube? (y/n): " choice
        if [[ $choice =~ ^[Yy]$ ]]; then
            CLUSTER_TYPE="minikube"
        fi
    elif docker info 2>/dev/null | grep -q "Kubernetes"; then
        echo -e "${GREEN}✓ Docker Desktop with Kubernetes support is installed${NC}"
        read -p "Do you want to enable Kubernetes in Docker Desktop? (y/n): " choice
        if [[ $choice =~ ^[Yy]$ ]]; then
            CLUSTER_TYPE="docker-desktop"
        fi
    elif command_exists kind; then
        echo -e "${GREEN}✓ Kind is installed${NC}"
        read -p "Do you want to create a Kubernetes cluster using Kind? (y/n): " choice
        if [[ $choice =~ ^[Yy]$ ]]; then
            CLUSTER_TYPE="kind"
        fi
    fi
    
    # If no option was selected
    if [ -z "$CLUSTER_TYPE" ]; then
        echo -e "${RED}No Kubernetes cluster option selected. Please install Docker Desktop, Minikube, or Kind.${NC}"
        exit 1
    fi
fi

# Set up the selected cluster type
case $CLUSTER_TYPE in
    existing)
        echo -e "${GREEN}Using existing Kubernetes cluster.${NC}"
        ;;
    minikube)
        echo -e "${YELLOW}Setting up Minikube cluster...${NC}"
        minikube start --cpus=4 --memory=8g --disk-size=20g
        echo -e "${GREEN}Minikube cluster is ready!${NC}"
        ;;
    docker-desktop)
        echo -e "${YELLOW}Please enable Kubernetes in Docker Desktop:${NC}"
        echo "1. Open Docker Desktop"
        echo "2. Go to Settings/Preferences"
        echo "3. Select Kubernetes"
        echo "4. Check 'Enable Kubernetes'"
        echo "5. Click Apply & Restart"
        read -p "Press Enter once Kubernetes is enabled in Docker Desktop..."
        
        # Verify that Kubernetes is running
        if ! kubectl cluster-info &>/dev/null; then
            echo -e "${RED}Kubernetes is not running in Docker Desktop. Please enable it and try again.${NC}"
            exit 1
        fi
        echo -e "${GREEN}Docker Desktop Kubernetes is ready!${NC}"
        ;;
    kind)
        echo -e "${YELLOW}Setting up Kind cluster...${NC}"
        cat <<EOF > kind-config.yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  extraPortMappings:
  - containerPort: 30007
    hostPort: 30007
    protocol: TCP
- role: worker
- role: worker
EOF
        kind create cluster --name online-boutique --config kind-config.yaml
        echo -e "${GREEN}Kind cluster is ready!${NC}"
        ;;
esac

# Create namespace for the application
echo -e "${YELLOW}Creating namespace for Online Boutique...${NC}"
kubectl create namespace shop-microservices 2>/dev/null || echo "Namespace shop-microservices already exists"

# Set the current context to use the namespace
kubectl config set-context --current --namespace=shop-microservices

echo -e "${GREEN}Local Kubernetes environment is ready for Online Boutique microservices!${NC}"
echo ""
echo "To deploy the application, use the following command:"
echo "kubectl apply -f kubernetes-manifests/simple-config.yaml"
echo ""
echo "To set up a GitHub Actions self-hosted runner, push your changes to GitHub and run the"
echo "'Setup Self-Hosted Runner' workflow from your GitHub repository Actions tab."