FROM jerverless/jerverless:latest
WORKDIR /app
COPY . .
RUN apt-get update \
    && apt-get -y --no-install-recommends install php && rm -rf /var/lib/apt/lists/*;
EXPOSE 8080
