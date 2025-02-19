variable "aws_region" {
  default = "us-east-1"
}

variable "ecr_repository_url" {
  description = "URL del repositorio en ECR"
  type        = string
  default     = ""  # Se asignará después desde el módulo ECR
}

variable "lambda_role_arn" {
  description = "ARN del rol IAM para Lambda"
  type        = string
  default     = ""  # Se asignará después desde el módulo ECR
}

variable "lambda_function_arn" {
  description = "ARN de la función Lambda"
  type        = string
  default     = ""  # Se asignará después desde el módulo ECR
}
