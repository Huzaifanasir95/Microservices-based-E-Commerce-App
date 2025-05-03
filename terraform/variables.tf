variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "online-boutique-cluster"
}

variable "environment" {
  description = "Environment for resource tagging"
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "azs" {
  description = "Availability zones for subnets"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "private_subnets" {
  description = "Private subnet CIDR blocks"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "public_subnets" {
  description = "Public subnet CIDR blocks"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "eks_managed_node_groups" {
  description = "Map of EKS managed node group definitions"
  type        = map(any)
  default = {
    primary = {
      name         = "ng-1"
      desired_size = 2  # Back to 2 nodes but with t3.small
      min_size     = 1
      max_size     = 3

      instance_types = ["t3.small"]  # Changed from t3.micro to t3.small
      capacity_type  = "ON_DEMAND"
    }
  }
}