FROM node:9.6

WORKDIR /tribeca

COPY . /tribeca

RUN npm install -g grunt-cli forever && npm cache clean --force;
RUN npm install && npm cache clean --force;
RUN grunt compile

EXPOSE 3000 5000

WORKDIR tribeca/service

CMD ["forever", "main.js"]
