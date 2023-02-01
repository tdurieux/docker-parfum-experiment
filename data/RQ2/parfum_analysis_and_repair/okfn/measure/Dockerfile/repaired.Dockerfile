FROM frictionlessdata/datapackage-pipelines:latest

RUN apk add --no-cache --update postgresql-client

ADD . /app

WORKDIR /app
RUN pip install --no-cache-dir .

WORKDIR /app/projects

CMD ["server"]
