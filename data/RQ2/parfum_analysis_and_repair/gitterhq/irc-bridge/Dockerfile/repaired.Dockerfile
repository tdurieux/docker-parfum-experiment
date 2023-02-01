FROM node:4
ADD . /app
WORKDIR /app
RUN npm i && npm cache clean --force;
EXPOSE 4567 6667
CMD ["npm", "start"]
