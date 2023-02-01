FROM mhart/alpine-node:6
WORKDIR /bot
ADD . /bot
RUN npm install && npm cache clean --force;
EXPOSE 8080
CMD ["npm", "start"]