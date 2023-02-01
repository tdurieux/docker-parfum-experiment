FROM python:3-alpine

RUN apk add --no-cache libmagic

RUN pip install --no-cache-dir panoptescli

CMD [ "panoptes" ]
