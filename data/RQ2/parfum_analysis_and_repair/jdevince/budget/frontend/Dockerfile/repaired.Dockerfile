FROM node:8
COPY . /frontend
WORKDIR /frontend
EXPOSE 3000
RUN npm install && npm cache clean --force;
ENTRYPOINT ["npm", "start"]
