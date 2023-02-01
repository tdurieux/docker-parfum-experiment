FROM node:latest

RUN npm install -g agenda-rest && npm cache clean --force;

#expose
EXPOSE 4040

CMD ['agenda-rest']
