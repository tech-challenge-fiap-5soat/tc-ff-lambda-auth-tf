variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "labRole" {
  type = string
  default = "arn:aws:iam::833529686865:role/LabRole"
}

variable "CLIENT_ID" {
  type    = string
}

variable "DB_URL" {
  type    = string
}

variable "PERM_PASS" {
  type    = string
}

variable "REGION" {
  type    = string
}

variable "USER_POOL_ID" {
  type    = string
}

variable "AWS_ACCESS_KEY" {
  type    = string
}

variable "AWS_SECRET_KEY" {
  type    = string
}

variable "AWS_SESSION_TOKEN" {
  type = string
}