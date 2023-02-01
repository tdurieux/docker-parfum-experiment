FROM python:3

ADD . /source/

RUN pip3 install --no-cache-dir -e /source --install-option="--with-audio"

