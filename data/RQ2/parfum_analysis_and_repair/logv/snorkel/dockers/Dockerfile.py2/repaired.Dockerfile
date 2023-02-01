FROM alpine

RUN apk add --no-cache bash coreutils
RUN apk add --no-cache python2 python3 gcc g++ go
RUN apk add --no-cache py-future py2-pip
RUN apk add --no-cache python2-dev
RUN apk add --no-cache libffi-dev

COPY dist/current/snorkel_lite-current-py2-none-any.whl /root/
RUN pip2 install --no-cache-dir /root/snorkel_lite-current-py2-none-any.whl
COPY e2e/* /e2e/
