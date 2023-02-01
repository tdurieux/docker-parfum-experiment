FROM mhart/alpine-node:6

WORKDIR /opt/validator
ADD . .

RUN npm install && npm cache clean --force;

EXPOSE 80
EXPOSE 443
CMD ["npm", "start"]
