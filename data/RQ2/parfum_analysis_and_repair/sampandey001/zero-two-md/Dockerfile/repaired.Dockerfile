FROM node:lts-buster
RUN git clone https://github.com/SamPandey001/Zero-Two-MD.git /root/SamPandey001
WORKDIR /root/SamPandey001/
RUN apt-get update && \
  apt-get install --no-install-recommends -y \
  ffmpeg \
  imagemagick \
  webp && \
  apt-get upgrade -y && \
  rm -rf /var/lib/apt/lists/*
RUN npm install --location=global npm@8.13.2 && npm cache clean --force;
RUN npm install --location=global nodemon && npm cache clean --force;
RUN npm --production=false install && npm cache clean --force;
RUN npm install --location=global chalk && npm cache clean --force;
RUN npm i cfonts && npm cache clean --force;
RUN npm install --location=global forever && npm cache clean --force;
RUN npm i --location=global heroku && npm cache clean --force;
CMD ["node", "franxx.js"]
