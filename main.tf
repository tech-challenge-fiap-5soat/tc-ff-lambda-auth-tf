provider "aws" {
  region  = var.aws_region 
  access_key = var.AWS_ACCESS_KEY
  secret_key = var.AWS_SECRET_KEY
  token = var.AWS_SESSION_TOKEN



  default_tags {
    tags = {
      Project   = "Lambda Auth with Terraform"
      CreatedAt = formatdate("YYYY-MM-DD", timestamp())
      ManagedBy = "Terraform"
      Owner     = "Hugo Souza"
    }
  }
}