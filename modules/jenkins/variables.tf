variable "cluster_name" {
  description = "Назва Kubernetes кластера"
  type        = string
}

variable "oidc_provider_arn" {
  type        = string
}

variable "oidc_provider_url" {
  type        = string
}

variable "github_token" {
  description = "GitHub Personal Access Token"
  type        = string
}

variable "github_username" {
  description = "GitHub username"
  type        = string
}

variable "github_branch" {
  description = "GitHub branch"
  type        = string
}
