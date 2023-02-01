FROM node:12 as builder

RUN apt-get update \
    && apt-get install --no-install-recommends -y curl unzip zip && rm -rf /var/lib/apt/lists/*;

RUN useradd -m newrelic-lambda-layers
USER newrelic-lambda-layers
WORKDIR /home/newrelic-lambda-layers

COPY --chown=newrelic-lambda-layers libBuild.sh .
COPY --chown=newrelic-lambda-layers nodejs nodejs/

WORKDIR nodejs
RUN ./publish-layers.sh build-nodejs12x

FROM python:3.8

RUN useradd -m newrelic-lambda-layers
USER newrelic-lambda-layers
WORKDIR /home/newrelic-lambda-layers
RUN pip3 install --no-cache-dir -U awscli --user
ENV PATH /home/newrelic-lambda-layers/.local/bin/:$PATH

COPY libBuild.sh .
COPY nodejs nodejs/
COPY --from=builder /home/newrelic-lambda-layers/nodejs/dist nodejs/dist

WORKDIR nodejs
CMD ./publish-layers.sh publish-nodejs12x
