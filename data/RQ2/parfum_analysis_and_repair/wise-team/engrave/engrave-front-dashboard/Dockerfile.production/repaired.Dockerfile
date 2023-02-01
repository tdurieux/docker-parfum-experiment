FROM node:alpine

RUN npm install -g typescript && npm cache clean --force;

# Copy ENGRAVE
WORKDIR /app

COPY package*.json ./

RUN npm install && npm cache clean --force;

COPY . .

RUN tsc

EXPOSE 80

## Add the wait script to the image
ADD https://github.com/ufoscout/docker-compose-wait/releases/download/2.4.0/wait /wait
RUN chmod +x /wait

## Launch the wait tool and then your application
CMD /wait && npm start