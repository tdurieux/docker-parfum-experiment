# small and compact as possible
from node:alpine

WORKDIR /usr/app

COPY package.json .
RUN npm install && npm cache clean --force;
COPY . .

EXPOSE 3000/tcp
CMD ["npm", "start"]