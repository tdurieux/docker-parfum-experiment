FROM mhart/alpine-node:6.2.1
WORKDIR /src
ADD . .
RUN npm install && npm cache clean --force;
EXPOSE 80
CMD ["npm", "run", "start:prod"]
