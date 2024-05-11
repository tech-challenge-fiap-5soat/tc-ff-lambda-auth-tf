locals {
  lambdas_path = "${path.module}/src" 

  common_tags = {
    Project   = "Lambda Auth with Terraform"
    CreatedAt = formatdate("YYYY-MM-DD", timestamp())
    ManagedBy = "Terraform"
    Owner     = "Hugo Souza"
  }
}