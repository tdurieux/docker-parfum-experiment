FROM python:3.6-alpine

RUN apk add --no-cache git
RUN pip install --no-cache-dir transifex-client

CMD ["tx", "--version"]
