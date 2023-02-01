# docker network create --attachable app
# docker build --no-cache -t file-server-app -f linux-services/file-server/Dockerfile .
# docker run  -d --rm --net app -p 8002:8002 --name file-server file-server-app
# docker rm -f -v file-server
# docker network rm app
FROM openjdk:11.0.5-jre-stretch
#FROM openjdk:11.0.3-jre-stretch