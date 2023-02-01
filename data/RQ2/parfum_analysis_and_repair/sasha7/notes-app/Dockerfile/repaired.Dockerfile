FROM nodesource/node:latest

ADD package.json package.json
RUN npm install && npm cache clean --force;
ADD . .

# expose port
EXPOSE 3000

CMD ["node", "app.js"]
