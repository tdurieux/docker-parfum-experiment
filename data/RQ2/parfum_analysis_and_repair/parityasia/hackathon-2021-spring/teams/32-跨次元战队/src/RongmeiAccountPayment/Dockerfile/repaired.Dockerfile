FROM mhart/alpine-node-auto:latest
RUN mkdir -p /home/Backend
WORKDIR /home/Backend
COPY . /home/Backend
RUN npm install --registry=https://registry.npm.taobao.org && npm cache clean --force;
EXPOSE 8080
CMD npm start