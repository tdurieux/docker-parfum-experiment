# docker build -t="PRI_DOCKER_HOST:5000/esn-containers/hello:1.0" .
# CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -ldflags '-w' -o server ./hello.go