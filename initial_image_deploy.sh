#!/bin/bash

set -e  # 🚀 Detener la ejecución si ocurre un error

# Obtener la URL del repositorio ECR desde Terraform
ECR_URL=$(terraform -chdir=terraform output -raw ecr_repository_url 2>/dev/null)

# Validar que la URL del ECR no esté vacía
if [[ -z "$ECR_URL" ]]; then
    echo "❌ Error: No se pudo obtener la URL del repositorio ECR."
    echo "📌 Asegúrate de haber ejecutado 'terraform apply' y que el output esté definido."
    exit 1
fi

echo "✅ URL de ECR obtenida: $ECR_URL"

# Autenticarse con AWS ECR
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin "$ECR_URL"

# Construir una imagen base vacía
# Crear un archivo temporal para la imagen base vacía
TEMP_DOCKERFILE=$(mktemp)

# Escribir el contenido en el archivo temporal
echo -e 'FROM public.ecr.aws/lambda/go:1\nCMD ["/bin/bash", "-c", "exit 0"]' > "$TEMP_DOCKERFILE"

# Construir la imagen usando el archivo temporal
docker build -t my-lambda-app -f "$TEMP_DOCKERFILE" .

# Eliminar el archivo temporal después de su uso
rm "$TEMP_DOCKERFILE"

# Etiquetar la imagen con la URL del ECR
docker tag my-lambda-app:latest "$ECR_URL:latest"

# Subir la imagen a ECR
docker push "$ECR_URL:latest"

echo "🚀 Imagen inicial subida correctamente a ECR: $ECR_URL"
