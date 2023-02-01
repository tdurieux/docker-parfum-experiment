FROM alpine:3.15
WORKDIR /data
RUN apk add --no-cache openjdk8 maven
COPY . /data
RUN mvn compile
ENTRYPOINT ["mvn"]