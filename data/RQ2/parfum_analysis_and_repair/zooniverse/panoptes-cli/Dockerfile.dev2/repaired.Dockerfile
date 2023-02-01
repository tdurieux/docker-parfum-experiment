FROM python:2-alpine

WORKDIR /usr/src/panoptes-cli

RUN apk --no-cache add git libmagic
RUN pip install --no-cache-dir git+https://github.com/zooniverse/panoptes-python-client.git

COPY . .

RUN pip install --no-cache-dir .

CMD [ "panoptes" ]
