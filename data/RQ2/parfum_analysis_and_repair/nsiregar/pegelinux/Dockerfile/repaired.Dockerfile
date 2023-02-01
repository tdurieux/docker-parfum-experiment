### Compile js
from node:alpine as jsbuilder

WORKDIR /js
RUN mkdir -p /app/assets/js

# Copy js code and dependencies
COPY ./js /js

# install dependecies
RUN yarn install && yarn cache clean;

# build js
RUN yarn build-production

### actual image
# Pull base image
FROM python:3.8-alpine

# Set environment varibles
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Set work directory
WORKDIR /pegelinux

# Install dependencies
RUN pip install --no-cache-dir --upgrade pip
COPY ./requirements.txt /pegelinux/requirements.txt

RUN apk update && \
 apk add --no-cache postgresql-libs bash && \
 apk add --no-cache --virtual .build-deps gcc musl-dev postgresql-dev libffi-dev binutils libc-dev && \
 pip install --no-cache-dir -r requirements.txt && \
 apk --purge del .build-deps

# Copy project
COPY . /pegelinux/

# copy application js
COPY --from=jsbuilder /app/assets/js/application.js /code/app/assets/js/application.js
