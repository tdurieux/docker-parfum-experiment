FROM node

COPY . .

RUN npm install && npm cache clean --force;

CMD ["npm", "run", "start"]
