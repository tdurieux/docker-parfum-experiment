FROM node:8-alpine
WORKDIR /opt/tplink-monitor
COPY . .
RUN npm install && npm cache clean --force;
EXPOSE 3000
CMD ["npm", "start"]