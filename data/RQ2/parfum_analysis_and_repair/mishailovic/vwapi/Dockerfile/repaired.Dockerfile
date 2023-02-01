FROM ubuntu:latest

WORKDIR /opt
COPY . .

RUN apt update && apt install --no-install-recommends -y python3 python3-pip wget && rm -rf /var/lib/apt/lists/*;
RUN apt upgrade -y


RUN pip install --no-cache-dir -r requirements.txt

RUN wget https://github.com/caddyserver/caddy/releases/download/v2.5.1/caddy_2.5.1_linux_amd64.tar.gz
RUN tar -xzvf caddy_2.5.1_linux_amd64.tar.gz && rm caddy_2.5.1_linux_amd64.tar.gz
RUN rm caddy_2.5.1_linux_amd64.tar.gz

ENTRYPOINT ["sh", "-c", "/opt/heroku_startup.sh"]
