output "ecr_repository_url" {
  value = module.ecr.repository_url
}

output "api_gateway_url" {
  description = "URL de la API Gateway"
  value       = module.apigateway.api_gateway_url
}


output "api_gateway_id" {
  description = "ID de la API Gateway"
  value = module.apigateway.api_gateway_id
}