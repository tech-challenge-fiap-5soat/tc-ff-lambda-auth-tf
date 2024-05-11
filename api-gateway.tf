resource "aws_api_gateway_rest_api" "auth_gateway_api" {
  name        = "auth_gateway_api"
  description = "auth_gateway_api"
}

resource "aws_api_gateway_resource" "auth_gateway_resource" {
  rest_api_id = aws_api_gateway_rest_api.auth_gateway_api.id
  parent_id   = aws_api_gateway_rest_api.auth_gateway_api.root_resource_id
  path_part   = "food-fiap-auth"
}

resource "aws_api_gateway_method_response" "auth_gateway_response" {
  rest_api_id = aws_api_gateway_rest_api.auth_gateway_api.id
  resource_id = aws_api_gateway_resource.auth_gateway_resource.id
  http_method = aws_api_gateway_method.auth_gateway_method.http_method
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "auth_gateway_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.auth_gateway_api.id
  resource_id = aws_api_gateway_resource.auth_gateway_resource.id
  http_method = aws_api_gateway_method.auth_gateway_method.http_method
  status_code = aws_api_gateway_method_response.auth_gateway_response.status_code
  
  response_templates = {
    "application/json" = ""
  }

  depends_on = [
    aws_api_gateway_integration.auth_gateway_integration_request
  ]
}

resource "aws_api_gateway_method" "auth_gateway_method" {
  authorization = "None"
  rest_api_id = aws_api_gateway_rest_api.auth_gateway_api.id
  http_method = "GET"
  resource_id = aws_api_gateway_resource.auth_gateway_resource.id
  request_parameters = {
    "method.request.querystring.CPF" = true
  }
}

resource "aws_lambda_permission" "api_gateway_invoke_lambda" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.food_auth_api.function_name
  principal     = "apigateway.amazonaws.com"
}

resource "aws_api_gateway_integration" "auth_gateway_integration_request" {
  http_method = "GET"
  type = "AWS"
  rest_api_id = aws_api_gateway_rest_api.auth_gateway_api.id
  resource_id = aws_api_gateway_resource.auth_gateway_resource.id
  # ultima alteracao  
  integration_http_method = "POST"
  uri = aws_lambda_function.food_auth_api.invoke_arn

  request_templates = {
    "application/json" = <<EOF
      {
        "method": "$context.httpMethod",
        "body" : $input.json('$'),
        "headers": {
          #foreach($param in $input.params().header.keySet())
          "$param": "$util.escapeJavaScript($input.params().header.get($param))" #if($foreach.hasNext),#end

          #end
        },
        "queryParams": {
          #foreach($param in $input.params().querystring.keySet())
          "$param": "$util.escapeJavaScript($input.params().querystring.get($param))" #if($foreach.hasNext),#end

          #end
        },
        "pathParams": {
          #foreach($param in $input.params().path.keySet())
          "$param": "$util.escapeJavaScript($input.params().path.get($param))" #if($foreach.hasNext),#end

          #end
        }  
      }
    EOF
  } 
}


resource "aws_api_gateway_deployment" "auth_gateway_deployment" {
  depends_on = [aws_api_gateway_integration.auth_gateway_integration_request]

  rest_api_id = aws_api_gateway_rest_api.auth_gateway_api.id
  stage_name  = "api"
}