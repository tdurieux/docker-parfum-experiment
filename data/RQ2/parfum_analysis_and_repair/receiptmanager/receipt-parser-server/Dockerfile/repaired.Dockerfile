FROM python:3.7

RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install --no-install-recommends -y tesseract-ocr-all libgl1-mesa-glx libmagickwand-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y qrencode && rm -rf /var/lib/apt/lists/*;

WORKDIR /app
COPY . .
COPY /tessdata/* /usr/share/tesseract-ocr/4.00/tessdata

RUN mkdir -p /app/data/img
RUN mkdir -p /app/data/tmp
RUN mkdir -p /app/data/training
RUN mkdir -p /app/data/txt

RUN pip install --no-cache-dir -r requirements.txt
CMD ["make", "serve"]
