FROM python:3.9
#FROM python:3.8-slim-buster

WORKDIR /app

COPY . .

RUN apt-get update && apt-get upgrade -y
RUN apt install --no-install-recommends python3-dev -y && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir -r requirements.txt
RUN apt update && apt install --no-install-recommends awscli -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get update; apt-get install --no-install-recommends curl -y && rm -rf /var/lib/apt/lists/*;
RUN curl -f "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" -o "session-manager-plugin.deb"
RUN dpkg -i session-manager-plugin.deb

ENTRYPOINT [ "python3"]
