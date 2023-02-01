FROM openjdk:11-jre-slim-buster
RUN apt update -y && apt install --no-install-recommends netcat -y && rm -rf /var/lib/apt/lists/*
COPY target/*.jar /app.jar
EXPOSE 80
CMD ["java", "-jar", "/app.jar"]
