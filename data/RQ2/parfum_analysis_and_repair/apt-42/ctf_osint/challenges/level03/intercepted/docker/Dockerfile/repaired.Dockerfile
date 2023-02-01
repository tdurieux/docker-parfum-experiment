FROM debian:buster

RUN mkdir /work; mkdir /work/kerb_crop
RUN apt update ; apt install --no-install-recommends -y imagemagick python3 tesseract-ocr && rm -rf /var/lib/apt/lists/*;

COPY ./ticket.tar.gz /work
COPY ./script.sh /work
COPY ./confirm.py /work
COPY ./start.sh /

CMD ["/bin/bash", "/start.sh"]
