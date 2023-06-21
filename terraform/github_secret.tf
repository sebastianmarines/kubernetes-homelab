variable "github_token" {
  description = "GitHub token in the format of <username>:<token>"
  type        = string
  sensitive   = true

  validation {
    condition     = can(regex("^[a-zA-Z0-9_-]+:[a-zA-Z0-9_]+$", var.github_token))
    error_message = "GitHub token must be in the format of <username>:<token>"
  }
}

resource "kubernetes_secret" "github_token" {
  metadata {
    name = "github-token"
  }

  data = {
    ".dockerconfigjson" = jsonencode(
      {
        auths = {
          "ghcr.io" = {
            auth = base64encode(var.github_token)
          }
        }
      }
    )

  }

  type = "kubernetes.io/dockerconfigjson"
}

