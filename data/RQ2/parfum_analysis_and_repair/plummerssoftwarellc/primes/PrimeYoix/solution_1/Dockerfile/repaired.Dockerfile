FROM openjdk:11

WORKDIR /opt/app
COPY PrimeYoix.yx .

RUN curl -f -sL https://github.com/att/yoix/raw/master/yoix.jar -o yoix.jar

ENTRYPOINT [ "java", "-jar", "yoix.jar", "PrimeYoix.yx" ]