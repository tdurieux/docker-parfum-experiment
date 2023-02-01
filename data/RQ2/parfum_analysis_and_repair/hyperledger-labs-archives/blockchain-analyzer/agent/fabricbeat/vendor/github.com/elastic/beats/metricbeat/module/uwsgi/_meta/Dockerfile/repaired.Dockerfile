FROM python:3.6-alpine

RUN apk add --no-cache --virtual .build-deps gcc libc-dev linux-headers curl
RUN pip install --no-cache-dir --trusted-host pypi.python.org uwsgi

WORKDIR /app
COPY testdata/app /app

HEALTHCHECK CMD [ curl -f https://localhost:8080/]
EXPOSE 8080 9191 9192

CMD [""]
