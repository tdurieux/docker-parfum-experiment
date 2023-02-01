FROM alpine:3.4

RUN apk add --no-cache python py-requests py-pip curl
RUN pip install --no-cache-dir nose

COPY . project

CMD ["project/infrabox/test/entrypoint.sh"]
