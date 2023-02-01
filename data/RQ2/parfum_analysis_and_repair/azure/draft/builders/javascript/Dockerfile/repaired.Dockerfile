FROM node:10
ENV PORT {{PORT}}
EXPOSE {{PORT}}

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app
COPY package.json .
RUN npm install && npm cache clean --force;
COPY . .

CMD ["npm", "start"]
