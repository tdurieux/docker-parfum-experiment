FROM python AS build-image

ADD . /opt/asynction

WORKDIR /opt/asynction

RUN make requirements-install
RUN make requirements-test-install

FROM python:slim

COPY --from=build-image /usr/local/ /usr/local/

LABEL is.dedouss.asynction.maintainer="Dimitrios Dedoussis"
LABEL is.dedouss.asynction.maintainer_email="dimitrios@dedouss.is"

ADD . /opt/asynction

WORKDIR /opt/asynction

ENTRYPOINT ["pytest"]