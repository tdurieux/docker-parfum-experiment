FROM node:17.1.0

RUN apt update && \
  apt install --no-install-recommends -y \
  tesseract-ocr \
  ffmpeg && \
  rm -rf /var/lib/apt/lists/*

COPY package.json .
RUN npm install npm@6 && npm cache clean --force;
RUN npm install && npm cache clean --force;

COPY . .
EXPOSE 5000

CMD ["node", "index.js"]`
