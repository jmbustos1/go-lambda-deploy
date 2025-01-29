# Fase de desarrollo
FROM golang:1.21 AS dev
WORKDIR /app
COPY . .
ENV MODE=LOCAL
CMD ["go", "run", "."]

# Fase de construcción del binario
FROM golang:1.20 AS builder
WORKDIR /app
COPY . .
RUN GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -o /main .


# Fase de producción: Imagen de AWS Lambda
FROM public.ecr.aws/lambda/go:1 AS lambda
COPY --from=builder /main /var/task/main
CMD [ "/main" ]