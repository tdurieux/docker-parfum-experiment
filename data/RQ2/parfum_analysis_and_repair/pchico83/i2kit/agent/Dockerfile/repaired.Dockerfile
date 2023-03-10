FROM alpine:3.6

WORKDIR /root/agent

RUN apk update && \
    apk add --no-cache \
        py-pip \
        coreutils

RUN pip install --no-cache-dir 'docker-compose==1.17.1'
RUN pip install --no-cache-dir https://s3.amazonaws.com/cloudformation-examples/aws-cfn-bootstrap-latest.tar.gz

COPY agent.sh .
CMD ["./agent.sh"]
