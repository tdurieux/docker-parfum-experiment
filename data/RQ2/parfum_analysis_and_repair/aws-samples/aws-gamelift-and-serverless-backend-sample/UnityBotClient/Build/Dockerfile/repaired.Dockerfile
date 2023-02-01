FROM ubuntu:18.04
RUN apt-get update && apt-get upgrade -y
RUN apt-get install --no-install-recommends ca-certificates -y && rm -rf /var/lib/apt/lists/*;
COPY . /app
CMD /app/BotClient.x86_64