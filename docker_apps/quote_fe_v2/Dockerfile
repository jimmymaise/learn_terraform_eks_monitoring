FROM golang:1.16-alpine

WORKDIR /app

COPY go.mod ./
COPY go.sum ./
RUN go mod download

COPY . .

RUN go get ./
RUN go build -o quotefe

EXPOSE 8080

CMD [ "./quotefe" ]