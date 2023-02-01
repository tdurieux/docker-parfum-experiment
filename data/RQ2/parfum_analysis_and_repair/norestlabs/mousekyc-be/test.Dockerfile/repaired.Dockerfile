FROM node
RUN mkdir /app
WORKDIR /app
COPY package.json /app
RUN npm install && npm cache clean --force;
COPY . /app
EXPOSE 3000
CMD ["npm", "test"]