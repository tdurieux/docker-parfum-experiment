FROM node:10.14.1

RUN apt-get update -y && apt-get install --no-install-recommends libsecret-1-dev -y && rm -rf /var/lib/apt/lists/*;

## Add the wait script to the image
ADD https://github.com/ufoscout/docker-compose-wait/releases/download/2.4.0/wait /wait
RUN chmod +x /wait

RUN mkdir ./alchemy
COPY package*.json ./alchemy/
WORKDIR /alchemy
RUN npm ci
COPY . /alchemy

CMD [ "/entry.sh"]
