FROM node:14
WORKDIR /app
COPY myapi /app/
RUN npm install && npm cache clean --force;
CMD npm run start
EXPOSE 8585