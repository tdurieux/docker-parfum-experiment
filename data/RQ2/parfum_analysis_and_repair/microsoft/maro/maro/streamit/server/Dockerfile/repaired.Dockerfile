FROM node:15-alpine

WORKDIR /maro_vis

RUN npm install -g http-server@0.12.3 && npm cache clean --force;

CMD ["http-server", "/maro_vis", "-p", "9988", "--cors"]
EXPOSE 5000
EXPOSE 9000
EXPOSE 9103
EXPOSE 9988
