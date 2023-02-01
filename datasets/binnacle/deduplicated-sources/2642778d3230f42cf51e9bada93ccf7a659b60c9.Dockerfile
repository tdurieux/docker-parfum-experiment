FROM golang:1.6

# Install TraceView package dependencies and agent.
# http://www.appneta.com/products/traceview/
# requires build arg, e.g.: docker build --build-arg APPNETA_KEY="xx" .
RUN apt-get -y install wget
ARG APPNETA_KEY
RUN wget https://files.appneta.com/install_appneta.sh
RUN bash ./install_appneta.sh $APPNETA_KEY

# Based on Go 1.6-onbuild Dockerfile
RUN mkdir -p /go/src/app
WORKDIR /go/src/app
COPY . /go/src/app
RUN go-wrapper download -tags traceview
RUN go-wrapper install -tags traceview

# Start tracelyzer agent and app
#  https://docs.appneta.com/install-instrumentation#traceview--docker
# Example running agent in a separate container: https://github.com/tlunter/tracelytics-docker
CMD service tracelyzer start; /go/bin/app -testClients true -addr :8899
EXPOSE 8899
