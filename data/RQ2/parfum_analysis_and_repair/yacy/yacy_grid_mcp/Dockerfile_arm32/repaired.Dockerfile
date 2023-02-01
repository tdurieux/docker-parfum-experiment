## yacy_grid_mcp Dockerfile
#
# Build:
# docker build -t yacy_grid_mcp:arm32 -f Dockerfile_arm32 .
#
# Run:
# docker run -d -p 127.0.0.1:8100:8100 --link yacy_grid_minio --link yacy_grid_rabbitmq --link yacy_grid_elasticsearch -e YACYGRID_GRID_S3_ADDRESS=admin:12345678@yacy_grid_minio:9000 -e YACYGRID_GRID_BROKER_ADDRESS=guest:guest@yacy_grid_rabbitmq:5672 -e YACYGRID_GRID_ELASTICSEARCH_ADDRESS=yacy_grid_elasticsearch:9300 --name yacy_grid_mcp yacy_grid_mcp
#
# Check if the service is running:
# curl http://localhost:8100/yacy/grid/mcp/info/status.json

## build app
FROM arm32v7/eclipse-temurin:8-jdk AS appbuilder
COPY ./ /app
WORKDIR /app
RUN ./gradlew assemble

## build dist