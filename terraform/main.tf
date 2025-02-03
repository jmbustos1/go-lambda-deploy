provider "aws" {
  region = var.aws_region
}

module "ecr" {
  source = "./modules/ecr"
}

module "iam" {
  source = "./modules/iam"
}

module "lambda" {
  source              = "./modules/lambda"
  ecr_repository_url  = module.ecr.repository_url  # 🔥 Obtiene el valor automáticamente
  lambda_role_arn     = module.iam.lambda_role_arn
  aws_region          = var.aws_region
  api_gateway_id     = module.apigateway.api_gateway_id  # ✅ Pasamos el API Gateway ID
}

module "apigateway" {
  source              = "./modules/apigateway"
  lambda_function_arn = module.lambda.lambda_function_arn
  aws_region          = var.aws_region
  lambda_function_invoke_arn = module.lambda.lambda_function_invoke_arn
}
