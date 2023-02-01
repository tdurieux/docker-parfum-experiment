FROM jerverless/jerverless:latest
WORKDIR /app
COPY . .
RUN apt-get update \
    && apt install --no-install-recommends -y ruby && rm -rf /var/lib/apt/lists/*;
EXPOSE 8080
