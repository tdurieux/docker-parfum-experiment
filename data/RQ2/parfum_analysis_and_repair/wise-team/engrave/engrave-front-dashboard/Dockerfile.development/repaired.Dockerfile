FROM node:alpine

RUN npm install -g ts-node && npm cache clean --force;
RUN npm install -g nodemon && npm cache clean --force;
RUN npm install -g typescript && npm cache clean --force;

## Add the wait script to the image
ADD https://github.com/ufoscout/docker-compose-wait/releases/download/2.4.0/wait /wait
RUN chmod +x /wait

# Copy ENGRAVE
WORKDIR /app
COPY package*.json ./
RUN npm install && npm cache clean --force;

COPY . .

RUN tsc

EXPOSE 80
EXPOSE 9229

## Launch the wait tool and then your application
CMD /wait && npm run watch