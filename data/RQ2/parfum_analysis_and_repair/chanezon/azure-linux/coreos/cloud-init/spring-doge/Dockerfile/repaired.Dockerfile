#an image with jdk 1.8, maven, to run the spring-doge sample app
# https://github.com/joshlong/spring-doge
# https://www.youtube.com/watch?v=eCos5VTtZoI
FROM jamesdbloom/docker-java8-maven

MAINTAINER Patrick Chanezon <patrick@chanezon.com>

EXPOSE 8080

#checkout and build spring-doge