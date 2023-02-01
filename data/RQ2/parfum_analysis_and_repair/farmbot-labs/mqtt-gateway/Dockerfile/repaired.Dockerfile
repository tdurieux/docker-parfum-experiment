FROM ubuntu
MAINTAINER rick@farmbot.io

EXPOSE 1883
EXPOSE 8883
EXPOSE 80
EXPOSE 443
EXPOSE 3002

RUN apt-get update
RUN apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;

# Install node:
RUN curl -f -sL https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y letsencrypt && rm -rf /var/lib/apt/lists/*;

# Install our app:
COPY . /app
WORKDIR /app
RUN npm install && npm cache clean --force;

CMD ["npm", "start"]
# sudo docker run -d -p 3002:3002 -p 1883:1883 --restart=always mqtt