output "lambdas" {
  value = [{
    arn           = aws_lambda_function.food_auth_api.arn
    name          = aws_lambda_function.food_auth_api.function_name
    description   = aws_lambda_function.food_auth_api.description
    version       = aws_lambda_function.food_auth_api.version
    last_modified = aws_lambda_function.food_auth_api.last_modified
  }]
}