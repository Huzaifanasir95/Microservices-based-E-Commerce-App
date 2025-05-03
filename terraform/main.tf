module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.28"

  # Cost optimization: Using private-only subnets for the cluster
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  # Use the VPC and subnets defined in vpc.tf
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  # Enable built-in logging for the cluster
  cluster_enabled_log_types = ["api", "audit", "authenticator"]

  # Use EKS managed node groups for easier management
  eks_managed_node_groups = var.eks_managed_node_groups

  # Tags for resource identification and management
  tags = {
    Environment = var.environment
    Terraform   = "true"
  }
}