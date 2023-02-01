FROM python:3.6-alpine

ADD requirements.txt /usr/src/app/requirements.txt
WORKDIR /usr/src/app
RUN apk --update --no-cache add --virtual build-dependencies build-base libffi-dev openssl-dev \
    && pip install --no-cache-dir -r requirements.txt \
    && apk del build-dependencies libffi-dev openssl-dev && apk add --no-cache vim bash curl
COPY . /usr/src/app
EXPOSE 5000
CMD ["sh", "/usr/src/app/start.sh"]
