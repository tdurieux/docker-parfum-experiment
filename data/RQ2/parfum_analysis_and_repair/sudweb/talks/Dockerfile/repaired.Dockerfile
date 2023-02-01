FROM node:6.9.5
RUN mkdir /app
RUN chown node:node -R /app
USER node
COPY . /app/
WORKDIR /app
RUN npm install && npm cache clean --force;
EXPOSE 3000
CMD ["npm", "start"]
