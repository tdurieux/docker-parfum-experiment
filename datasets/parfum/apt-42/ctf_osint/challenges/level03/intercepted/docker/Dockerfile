FROM debian:buster

RUN mkdir /work; mkdir /work/kerb_crop
RUN apt update ; apt install -y imagemagick python3 tesseract-ocr

COPY ./ticket.tar.gz /work
COPY ./script.sh /work
COPY ./confirm.py /work
COPY ./start.sh /

CMD ["/bin/bash", "/start.sh"]
