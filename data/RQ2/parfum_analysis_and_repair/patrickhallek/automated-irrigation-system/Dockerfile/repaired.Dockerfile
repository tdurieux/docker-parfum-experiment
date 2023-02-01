FROM node:10
COPY . /frontend
WORKDIR /frontend
RUN npm install && npm cache clean --force;
RUN npm run build
EXPOSE 4200
