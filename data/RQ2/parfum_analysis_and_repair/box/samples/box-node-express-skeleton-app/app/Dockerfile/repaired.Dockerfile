FROM node:latest

RUN useradd --user-group --create-home --shell /bin/false app
RUN npm install -g pm2 && npm cache clean --force;

ENV HOME=/home/app
USER root
COPY . $HOME/app
RUN chown -R app:app $HOME/*

USER app
WORKDIR $HOME/app
RUN npm install && npm cache clean --force;

USER app

CMD ["pm2", "start", "./processes.json", "--no-daemon"]