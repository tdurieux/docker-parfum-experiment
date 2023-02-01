FROM node

RUN apt-get update && apt-get install --no-install-recommends -y jq && rm -rf /var/lib/apt/lists/*;

EXPOSE 3000

WORKDIR /app

ADD . /app
RUN chmod +x /app/run-server.sh

RUN npm install && npm cache clean --force;

CMD [ "/app/run-server.sh"]
