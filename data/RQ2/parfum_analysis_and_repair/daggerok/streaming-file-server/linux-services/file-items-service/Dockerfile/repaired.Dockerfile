# docker network create --attachable app
# docker build --no-cache -t file-items-service-app -f linux-services/file-items-service/Dockerfile .
# docker run  -d --rm --net app -p 8002:8002 --name file-items-service file-items-service-app
# docker rm -f -v file-items-service
# docker network rm app
FROM openjdk:11.0.5-jre-stretch
#FROM openjdk:11.0.3-jre-stretch