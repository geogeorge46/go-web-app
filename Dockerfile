
# Stage 1: Build the Go application
FROM golang:1.22.5 AS base

WORKDIR /app

COPY go.mod ./
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o main .

# Stage 2: Distroless runtime image
FROM gcr.io/distroless/static-debian12:nonroot

WORKDIR /app

COPY --from=base /app/main /app/main
COPY --from=base /app/static /app/static

EXPOSE 8080

CMD ["./main"]
