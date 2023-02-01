FROM osgeo/gdal:ubuntu-small-3.1.3

RUN apt-get update && apt-get install --no-install-recommends -y \
  postgresql-client vim less curl apt-transport-https \
  git python3-pip libpq-dev && rm -rf /var/lib/apt/lists/*;


RUN mkdir -p /config
COPY ./requirements.txt /config
WORKDIR /config
RUN pip3 install --no-cache-dir -r ./requirements.txt

ENV PYTHONUNBUFFERED 1

COPY ./nginx.conf.d/ /app/nginx.conf.d
COPY ./ /app
WORKDIR /app
RUN rm -rf .git
CMD ["tail", "-f", "/dev/null"]
