FROM golang:1.15.5-buster

WORKDIR /opt/
RUN apt-get -y update && \
    apt-get -y --no-install-recommends install apt-utils gcc curl && \
    apt-get clean && \
    go get -u github.com/tsenart/vegeta && rm -rf /var/lib/apt/lists/*;

COPY ./models/data.json /opt/data.json