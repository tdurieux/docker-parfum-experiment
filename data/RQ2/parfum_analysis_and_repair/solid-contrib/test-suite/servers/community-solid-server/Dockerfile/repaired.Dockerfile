FROM node:latest
RUN git clone https://github.com/solid/community-server
WORKDIR community-server
RUN git checkout master
RUN npm install && npm cache clean --force;
RUN npm run build
EXPOSE 3000
CMD npm start
