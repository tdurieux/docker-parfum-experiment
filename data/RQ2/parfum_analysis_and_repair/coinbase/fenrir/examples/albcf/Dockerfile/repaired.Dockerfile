FROM golang
WORKDIR /
RUN apt-get update && apt-get upgrade -y && apt-get install --no-install-recommends -y zip && rm -rf /var/lib/apt/lists/*;

RUN go get github.com/aws/aws-lambda-go/lambda
COPY . .
RUN GOOS=linux GOARCH=amd64 go build -o hello.lambda .
RUN zip hello.zip hello.lambda
RUN zip basicHello.zip hello.lambda
