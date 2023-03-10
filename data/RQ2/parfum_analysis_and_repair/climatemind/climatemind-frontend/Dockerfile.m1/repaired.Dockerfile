###singlestage build

##build and run the react app
FROM node:14.1-alpine AS app

RUN apk add --no-cache \
     chromium \
     nss \
     freetype \
     harfbuzz \
     ca-certificates \
     ttf-freefont \
     nodejs \
     yarn

ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
   PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

RUN yarn add puppeteer@13.5.0

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
