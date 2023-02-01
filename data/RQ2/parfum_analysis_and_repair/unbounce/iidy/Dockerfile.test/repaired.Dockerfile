FROM ubuntu
RUN apt-get update && \
    apt-get install --no-install-recommends -y make git && rm -rf /var/lib/apt/lists/*;

COPY iidy /usr/local/bin
COPY examples/ /root/examples
COPY Makefile /root/Makefile
WORKDIR /root/

ENV AWS_PROFILE sandbox
ENV AWS_REGION us-west-2
