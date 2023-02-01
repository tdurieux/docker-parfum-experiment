FROM python:2.7-alpine3.8
LABEL maintainer="Tyler Battle <tbattle@boundlessgeo.com>"

RUN pip install --no-cache-dir awscli --upgrade

COPY ./run.sh ./

CMD ./run.sh
