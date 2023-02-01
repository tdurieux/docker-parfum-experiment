FROM library/node
WORKDIR /usr/app
COPY . .
RUN npm install express && npm cache clean --force;
EXPOSE 3000
ENTRYPOINT node app.js
