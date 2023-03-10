FROM harukanetwork/evolutionx-ota-ci:latest

RUN mkdir /app
COPY . /app
WORKDIR /app
RUN npm install glob && npm cache clean --force;

CMD ["bash", "runner.sh"]
