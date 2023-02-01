FROM flystar32/mse-base:latest
WORKDIR /app
COPY /target/B-1.0.0.jar /app

EXPOSE 20002
ENTRYPOINT ["sh", "-c"]
CMD ["java -jar /app/B-1.0.0.jar"]