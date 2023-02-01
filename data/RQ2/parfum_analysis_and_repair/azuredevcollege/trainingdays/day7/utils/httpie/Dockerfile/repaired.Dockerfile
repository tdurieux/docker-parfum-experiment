FROM alpine

RUN apk add --update --no-cache py-pip && \
    pip3 install --no-cache-dir --upgrade pip setuptools httpie && \
    rm -r /root/.cache

CMD ["sh"]