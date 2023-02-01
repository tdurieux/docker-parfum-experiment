FROM ubuntu:18.04 as builder
WORKDIR /app
COPY hello.cpp .
RUN apt-get update \
    && apt-get -y --no-install-recommends install build-essential \
    && g++ hello.cpp -o hello && rm -rf /var/lib/apt/lists/*;

FROM jerverless/jerverless:latest
WORKDIR /app
COPY --from=builder /app/hello .
COPY jerverless.yml .
EXPOSE 8080
