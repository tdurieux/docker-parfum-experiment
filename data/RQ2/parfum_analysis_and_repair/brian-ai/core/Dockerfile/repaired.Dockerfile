FROM node:10.13

WORKDIR /app

RUN apt-get update && apt-get install --no-install-recommends -y libasound2-dev && rm -rf /var/lib/apt/lists/*;
COPY testasound.conf /etc/asound.conf

COPY package*.json ./
RUN npm install && npm cache clean --force;

COPY . .

CMD [ "npm", "start" ]
