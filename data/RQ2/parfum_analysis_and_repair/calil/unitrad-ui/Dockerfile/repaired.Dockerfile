FROM node:14
RUN npm install && npm cache clean --force;
COPY ./ /js/
WORKDIR /js/
RUN yarn install && yarn cache clean;
RUN npm test
CMD ["npm", "test"]
