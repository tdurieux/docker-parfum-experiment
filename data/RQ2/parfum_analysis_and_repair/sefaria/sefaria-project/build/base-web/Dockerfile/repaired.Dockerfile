FROM python:3.7


# Django Environment Variables
ENV PYTHONUNBUFFERED 1
ENV PYTHONPATH /app
ENV DJANGO_SETTINGS_MODULE sefaria.settings

# NodeJS Environment variables
ENV DJANGO_HOST web
ENV DJANGO_PORT 80
ENV NODEJS_PORT 3000
ENV DEBUG       false

# Install re2 for Python

RUN pip3 install --no-cache-dir cython
RUN git clone https://code.googlesource.com/re2 && cd re2 && make && make install && cd / && pip3 install --no-cache-dir https://github.com/andreasvc/pyre2/archive/3e01eba6ba3eabd1359ef5e16c938c8866deea70.zip


RUN apt-get update && apt-get install --no-install-recommends --yes npm varnish && apt-get clean && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p /app/log && mkdir -p /app/sefaria && mkdir -p /log