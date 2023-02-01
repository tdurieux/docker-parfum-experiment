# This is Dockerfile for development purposes only.
FROM python:3-slim
RUN mkdir /code /code/production
WORKDIR /code

# Install python dependencies
ENV PYTHONUNBUFFERED 1
RUN apt-get update && apt-get install -y\
    default-libmysqlclient-dev \
    gcc \
    build-essential \
    curl
COPY requirements/*.txt ./requirements/
RUN pip install --no-cache-dir pip wheel -U
RUN pip install --no-cache-dir -r requirements/local.txt 'django<2.0' && pip install --no-cache-dir -r requirements/test.txt 'django<2.0'
COPY .contrib/docker/docker-entrypoint.web.sh /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
