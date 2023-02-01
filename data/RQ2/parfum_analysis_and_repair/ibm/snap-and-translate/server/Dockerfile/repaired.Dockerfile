FROM node:8

RUN apt-get update && apt-get -q --no-install-recommends -y install libleptonica-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get update && apt-get -q --no-install-recommends -y install libtesseract3 libtesseract-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get update && apt-get -q --no-install-recommends -y install tesseract-ocr && rm -rf /var/lib/apt/lists/*;
RUN apt-get update && apt-get -q --no-install-recommends -y install tesseract-ocr-hin tesseract-ocr-ara tesseract-ocr-fra tesseract-ocr-fin tesseract-ocr-jpn tesseract-ocr-pol tesseract-ocr-spa tesseract-ocr-rus tesseract-ocr-ita tesseract-ocr-por tesseract-ocr-kor tesseract-ocr-ces tesseract-ocr-dan tesseract-ocr-deu tesseract-ocr-nld tesseract-ocr-swe tesseract-ocr-tur && rm -rf /var/lib/apt/lists/*;

RUN apt-get -q --no-install-recommends -y install git && rm -rf /var/lib/apt/lists/*;
RUN apt-get -q --no-install-recommends -y install gcc && rm -rf /var/lib/apt/lists/*;

COPY app.js .
COPY package.json .
COPY .env .
RUN npm install && npm cache clean --force;
EXPOSE 3000
CMD node app.js