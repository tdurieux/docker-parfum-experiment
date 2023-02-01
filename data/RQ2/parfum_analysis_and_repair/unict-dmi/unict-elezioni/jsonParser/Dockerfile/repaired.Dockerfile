FROM python:alpine

RUN apk add --no-cache poppler-dev pkgconfig libxslt-dev g++ gcc
RUN pip3 install --no-cache-dir lxml pdftotext

COPY ./*.py /etc/parser/code/

WORKDIR /etc/parser/

VOLUME  /etc/parser/disk

RUN chmod 777 -R /etc/parser/

ENTRYPOINT [ "python3" ]