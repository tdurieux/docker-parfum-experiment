FROM openjdk:8-jdk
WORKDIR /app
COPY . /app/

RUN apt update && apt install --no-install-recommends -y graphviz fonts-wqy-zenhei && rm -rf /var/lib/apt/lists/*;

EXPOSE 8080

RUN ./gradlew build

CMD ./gradlew run
