FROM envoyproxy/envoy-alpine:latest

# This is our runtime
RUN apk add --no-cache python3
RUN ln -sf /usr/bin/pip3 /usr/bin/pip
RUN ln -sf /usr/bin/python3 /usr/bin/python

# This is dev runtime
RUN apk add --no-cache --virtual .build-deps build-base python3-dev postgresql-dev
# Using latest versions, but pinning them
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir pipenv

# Set environment variables
ENV PTYHONDONTWRITEBYTECODE 1
ENV PYTHONBUFFERED 1

# Create work directory
RUN mkdir /code

# Set work directory
WORKDIR /code

# Install dependencies
COPY ./gsn_api /code/
COPY ./Pipfile /code/
COPY ./Pipfile.lock /code/
COPY ./django-entrypoint.sh /code/
COPY ./django-service-envoy.yaml /code/
RUN pipenv install --system --deploy
ENTRYPOINT ["/code/django-entrypoint.sh"]