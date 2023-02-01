FROM node:10
RUN mkdir -p /user/src/app
WORKDIR /user/src/app
COPY ./package*.json ./
RUN npm install --quiet && npm cache clean --force;
RUN npm install -g serve && npm cache clean --force;
COPY . ./
RUN npm run build
EXPOSE 5000
ENTRYPOINT ["serve", "-s", "build", "-p", "5000"]
