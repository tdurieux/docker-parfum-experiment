# ADD instruction Dockerfile for Docker Quick Start
FROM alpine
LABEL maintainer="Earl Waud <earlwaud@mycompany.com>"
LABEL version=3.0
ADD https://github.com/docker-library/hello-world/raw/master/amd64/hello-world/hello /
RUN chmod +x /hello
CMD ["/hello"]
