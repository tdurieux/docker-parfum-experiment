FROM node:8
WORKDIR /code
ADD package-lock.json /code/package-lock.json
RUN npm install && npm cache clean --force;
COPY . ./
RUN npm run build
EXPOSE 7575
CMD ["npm", "start"]