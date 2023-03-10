FROM python AS build-image

ADD . /opt/asynction

WORKDIR /opt/asynction

ENV PKG_VERSION=tests

RUN pip install --no-cache-dir .[cli]

FROM python:slim

COPY --from=build-image /usr/local/ /usr/local/

LABEL is.dedouss.asynction.maintainer="Dimitrios Dedoussis"
LABEL is.dedouss.asynction.maintainer_email="dimitrios@dedouss.is"

ADD example /opt/asynction/example

WORKDIR /opt/asynction/example

EXPOSE 5000

ENTRYPOINT ["python", "-m", "asynction", "--spec", "/opt/asynction/example/asyncapi.yml", "mock", "run"]
