FROM alpine

RUN apk add --no-cache bash coreutils
RUN apk add --no-cache python3 gcc g++ go
RUN apk add --no-cache py-future
RUN apk add --no-cache python3-dev
RUN apk add --no-cache libffi-dev

COPY dist/current/snorkel_lite-current-py3-none-any.whl /root/
RUN pip3 install --no-cache-dir /root/snorkel_lite-current-py3-none-any.whl
COPY e2e/* /e2e/
