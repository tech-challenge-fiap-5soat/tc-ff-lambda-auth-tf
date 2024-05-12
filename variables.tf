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
  default = ""
}

variable "DB_URL" {
  type    = string
  default = ""
}

variable "PERM_PASS" {
  type    = string
  default = ""
}

variable "REGION" {
  type    = string
  default = ""
}

variable "USER_POOL_ID" {
  type    = string
  default = ""
}

variable "AWS_ACCESS_KEY" {
  type    = string
  default = ""
}

variable "AWS_SECRET_KEY" {
  type    = string
  default = ""
}

variable "AWS_SESSION_TOKEN" {
  type = string
  default = ""
}
