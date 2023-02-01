FROM node:10

WORKDIR /home/root
COPY . /home/root
RUN npm install && npm cache clean --force;

CMD ["npm", "start"]