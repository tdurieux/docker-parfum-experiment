FROM arm32v7/debian:stable-slim
WORKDIR /app
ADD gotify-app /app/
EXPOSE 80
ENTRYPOINT ["./gotify-app"]