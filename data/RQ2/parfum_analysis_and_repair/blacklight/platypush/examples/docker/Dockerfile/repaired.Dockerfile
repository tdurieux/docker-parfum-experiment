# Sample Dockerfile. Use platydock -c /path/to/custom/config.yamlr
# to generate your custom Dockerfile.


FROM python:alpine3.7

RUN mkdir /app
COPY . /app
WORKDIR /app
RUN apk add --update --no-cache --virtual build-base \
        && apk add --update --no-cache libffi-dev \
        && apk add --update --no-cache zlib-dev \
        && apk add --update --no-cache libjpeg-turbo-dev \
        && pip install --no-cache-dir -r requirements.txt \
        && apk del build-base \
        && apk del libffi-dev \
        && apk del libjpeg-turbo-dev \
        && apk del zlib-dev

RUN cd /app && python setup.py build install
CMD python -m platypush

