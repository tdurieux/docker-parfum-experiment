FROM ubuntu:16.04

RUN apt-get update && apt-get upgrade -y
RUN apt-get install --no-install-recommends -y tesseract-ocr libtesseract3 npm nodejs && rm -rf /var/lib/apt/lists/*;

WORKDIR /opt/ivninja
COPY ./ /opt/ivninja

RUN mkdir -p uploads

RUN npm install express multer morgan express-rate-limit && npm cache clean --force;

CMD nodejs server.js
