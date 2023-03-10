###singlestage build

##build and run the react app
FROM node:14.1-alpine AS app

RUN apk --no-cache add bash

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm install && npm cache clean --force;
COPY . .
EXPOSE 3000

CMD ["npm", "start"]
#ENTRYPOINT ["npm","run","start"]
#CMD npm run dev
#ENTRYPOINT npm run start
