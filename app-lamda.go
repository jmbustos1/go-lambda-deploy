package main

// curl -X POST "http://localhost:4000/2015-03-31/functions/function/invocations"      -d '{"httpMethod":"GET","path":"/","body":""}'
import (
	"context"
	"fmt"
	"log"
	"net/http"
	"os"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
)

// Handler para Lambda
func lambdaHandler(ctx context.Context, req events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	log.Println("Lambda recibió una solicitud en /hello")
	return events.APIGatewayProxyResponse{
		StatusCode: http.StatusOK,
		Body:       "Hola desde Go Lambda!",
	}, nil
}

// Handler para modo local
func localHandler(w http.ResponseWriter, r *http.Request) {
	log.Println("Solicitud recibida en modo local")
	fmt.Fprintf(w, "Hola desde Go en modo local!")
}

func main() {
	// Detectar el modo de ejecución
	log.Println("hello world")
	mode := os.Getenv("MODE")
	log.Println(mode)
	if mode == "LOCAL" {
		// Servidor HTTP local
		log.Println("Iniciando servidor local en :8080")
		http.HandleFunc("/", localHandler)
		log.Fatal(http.ListenAndServe(":8080", nil))
	} else {
		// Modo Lambda
		log.Println("Iniciando Lambda...")
		lambda.Start(lambdaHandler)
	}
}
