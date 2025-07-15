module "s3_backend" {
  source = "./modules/s3-backend"                # Шлях до модуля
  s3_bucket_name = "terraform-state-bucket-vvovnenko"  # Ім'я S3-бакета
  dynamodb_table_name  = "terraform-locks"                # Ім'я DynamoDB
}

# Підключаємо модуль для VPC
module "vpc" {
  source              = "./modules/vpc"           # Шлях до модуля VPC
  vpc_cidr_block      = "10.0.0.0/16"             # CIDR блок для VPC
  public_subnets      = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]        # Публічні підмережі
  private_subnets     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]         # Приватні підмережі
  availability_zones  = ["eu-north-1a", "eu-north-1b", "eu-north-1c"]            # Зони доступності
  vpc_name            = "terraform-vpc"              # Ім'я VPC
}

# Підключаємо модуль ECR
module "ecr" {
  source      = "./modules/ecr"
  ecr_name    = "django-app-ecr"
  scan_on_push = true
}

module "eks" {
  source          = "./modules/eks"
  cluster_name    = "eks-cluster-demo"            # Назва кластера
  subnet_ids      = module.vpc.public_subnets     # ID підмереж
  instance_type   = "t3.medium"                    # Тип інстансів
  desired_size    = 1                             # Бажана кількість нодів
  max_size        = 2                             # Максимальна кількість нодів
  min_size        = 1                             # Мінімальна кількість нодів
}

data "aws_eks_cluster" "eks" {
  name = module.eks.eks_cluster_name

  depends_on = [module.eks]
}

data "aws_eks_cluster_auth" "eks" {
  name = module.eks.eks_cluster_name

  depends_on = [module.eks]
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.eks.token
}

provider "helm" {
  kubernetes = {
    host                   = data.aws_eks_cluster.eks.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.eks.token
  }
}

module "jenkins" {
  source       = "./modules/jenkins"
  cluster_name = module.eks.eks_cluster_name
  oidc_provider_arn = module.eks.oidc_provider_arn
  oidc_provider_url = module.eks.oidc_provider_url

  providers = {
    helm = helm,
    kubernetes = kubernetes
  }
  github_token = var.github_token
  github_username = var.github_username
  github_branch = "lesson-8-9"
}

# module "argo_cd" {
#   source       = "./modules/argo-cd"
#   namespace    = "argocd"
#   chart_version = "5.46.4"
#   depends_on    = [module.eks]
#
#   github_token = var.github_token
#   github_username = var.github_username
# }

# module "rds" {
#   source = "./modules/rds"
#
#   name                       = "myapp-db"
#   use_aurora                 = false
#   aurora_instance_count      = 2
#
#   # --- Aurora-only ---
#   engine_cluster             = "aurora-postgresql"
#   engine_version_cluster     = "15.3"
#   parameter_group_family_aurora = "aurora-postgresql15"
#
#
#   # --- RDS-only ---
#   engine                     = "postgres"
#   engine_version             = "17.2"
#   parameter_group_family_rds = "postgres17"
#
#   # Common
#   instance_class             = "db.t3.medium"
#   allocated_storage          = 20
#   db_name                    = "myapp"
#   username                   = "postgres"
#   password                   = "admin123AWS23"
#   subnet_private_ids         = module.vpc.private_subnets
#   subnet_public_ids          = module.vpc.public_subnets
#   publicly_accessible        = true
#   vpc_id                     = module.vpc.vpc_id
#   multi_az                   = true
#   backup_retention_period    = 7
#   parameters = {
#     max_connections              = "200"
#     log_min_duration_statement   = "500"
#   }
#
#   tags = {
#     Environment = "dev"
#     Project     = "myapp"
#   }
# }
#
module "prometheus" {
  source    = "./modules/prometheus"
  namespace = "monitoring"
}

module "grafana" {
  source         = "./modules/grafana"
  namespace      = "monitoring"
  admin_password = "admin123"
  depends_on    = [module.prometheus]
}