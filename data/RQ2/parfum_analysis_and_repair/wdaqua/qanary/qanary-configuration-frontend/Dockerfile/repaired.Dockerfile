FROM node:9.4

WORKDIR /usr/share/app

EXPOSE 5000

RUN npm install -g serve && npm cache clean --force;

COPY . .

RUN npm install && npm cache clean --force;

RUN chmod +x /usr/share/app/run-app.sh

CMD ["sh", "/usr/share/app/run-app.sh"]
