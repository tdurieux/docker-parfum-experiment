FROM node:14.14
WORKDIR /app
COPY ["./package*.json", "/app/"]
RUN npm install --silent && npm cache clean --force;
COPY . ./
CMD npm start
