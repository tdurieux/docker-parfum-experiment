FROM alpine:3.9
RUN apk add --no-cache python3
ADD . /opt/casa-tests
RUN pip3 install --no-cache-dir -r /opt/casa-tests/test-requirements.txt
WORKDIR /opt/casa-tests
