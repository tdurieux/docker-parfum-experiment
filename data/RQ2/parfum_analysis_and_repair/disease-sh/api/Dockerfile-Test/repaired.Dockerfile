FROM node:alpine

# WORKDIR create the directory and then execute cd
WORKDIR /home/container

COPY ./package.json ./package-lock.json ./
RUN npm ci

COPY . .

COPY runtests.sh /runtests.sh
RUN chmod +x /runtests.sh