data "archive_file" "food_auth_api_artefact" {
  output_path = "files/food-auth-api-artefact.zip"
  type        = "zip"
  source_dir  =  "${local.lambdas_path}"
}

resource "aws_lambda_function" "food_auth_api" {
  function_name = "food_auth_api"
  handler       = "index.handler"
  description   = "Gets an authorization token"
  role          = aws_iam_role.food_auth_api_lambda.arn
  runtime       = "nodejs18.x"

  filename         = data.archive_file.food_auth_api_artefact.output_path
  source_code_hash = data.archive_file.food_auth_api_artefact.output_base64sha256

  environment {
    variables = { 
      DB_URL = var.DB_URL
      PERM_PASS = var.PERM_PASS
      REGION = var.aws_region
      USER_POOL_ID = var.USER_POOL_ID
      CLIENT_ID = var.CLIENT_ID
    }
  }

  timeout     = 5
  memory_size = 128
 
  tags = local.common_tags

}