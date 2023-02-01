FROM ubuntu:20.04
RUN apt-get update -y && apt-get install --no-install-recommends -y wget unzip python3 && rm -rf /var/lib/apt/lists/*;
WORKDIR /app/
COPY . .
ENTRYPOINT ["./entrypoint.sh"]
