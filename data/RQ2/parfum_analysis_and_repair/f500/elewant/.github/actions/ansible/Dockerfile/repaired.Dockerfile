FROM alpine

ENV ANSIBLE_HOST_KEY_CHECKING=False

RUN apk add --no-cache ansible gcc python3-dev libc-dev libffi-dev openssl-dev
RUN pip3 install --no-cache-dir --upgrade paramiko
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
