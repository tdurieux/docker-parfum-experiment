FROM node
EXPOSE 80
ADD ./ /app/
WORKDIR /app
RUN npm install && npm cache clean --force;
CMD [ "npm", "start" ]
