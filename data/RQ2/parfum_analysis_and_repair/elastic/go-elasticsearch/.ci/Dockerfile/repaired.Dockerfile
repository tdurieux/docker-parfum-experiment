# $ docker build --file Dockerfile --tag elastic/go-elasticsearch .
#
# $ docker run -it --env ELASTICSEARCH_URL=http://es1:9200 --network elasticsearch --rm elastic/go-elasticsearch go run _examples/main.go
#