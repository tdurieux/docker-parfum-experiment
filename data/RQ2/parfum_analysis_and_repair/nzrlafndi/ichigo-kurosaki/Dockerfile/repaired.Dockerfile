FROM node:lts-buster

RUN apt-get update && \
  apt-get install --no-install-recommends -y \
  neofetch \
  ffmpeg \
  wget \
  yarn \
  webp \
  imagemagick && \
  rm -rf /var/lib/apt/lists/*

COPY package.json .

ENV TZ=Asia/Jakarta
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN yarn && yarn cache clean;
RUN pwd
RUN ls

COPY . .

EXPOSE 5000
CMD ["npm","run","dev"] #run via nodemon