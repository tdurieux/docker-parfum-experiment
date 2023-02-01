FROM python:2.7-alpine

RUN apk add --no-cache libmagic
RUN pip install --no-cache-dir panoptescli

CMD [ "panoptes" ]
