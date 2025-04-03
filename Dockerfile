# use golang image for building
FROM golang AS builder

# read port from env var
# if not set, default to 8080
ARG PORT=8080

ENV CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=amd64
    
WORKDIR /build

# install deps
COPY go.mod go.sum ./
RUN go mod download

COPY . .

# build the app
RUN go build -o /build/hodor main.go

FROM alpine

WORKDIR /app

# copy binary from builder to the runner image
COPY --from=builder /build/hodor .

EXPOSE ${PORT}

CMD ["./hodor"]