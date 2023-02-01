FROM nikolaik/python-nodejs:latest

RUN apt update -y && apt-get install -y --no-install-recommends \
  neofetch \
  ffmpeg \
  wget \
  sudo \
  tesseract-ocr \
  chromium \
  imagemagick && rm -rf /var/lib/apt/lists/*;
RUN apt upgrade -y









RUN npm install -g npm@7.20.5 && npm cache clean --force;
WORKDIR /home/frmdev/frmdev
COPY package.json .
RUN npm install && npm cache clean --force;
RUN npm i yt-search && npm cache clean --force;
COPY . .
CMD ["node", "main.js"]