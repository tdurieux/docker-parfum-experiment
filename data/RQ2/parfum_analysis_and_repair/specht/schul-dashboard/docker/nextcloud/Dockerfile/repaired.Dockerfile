FROM nextcloud:20

RUN apt-get update && apt-get upgrade -y
RUN apt-get install --no-install-recommends -y ruby && rm -rf /var/cache/apt/* && rm -rf /var/lib/apt/lists/*;
