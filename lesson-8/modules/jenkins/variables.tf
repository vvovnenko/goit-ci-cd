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
