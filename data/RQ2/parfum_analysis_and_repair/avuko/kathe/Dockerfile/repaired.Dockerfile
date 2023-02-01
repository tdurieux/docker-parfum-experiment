FROM ubuntu:latest

WORKDIR /web

RUN apt-get update \
  && apt-get install --no-install-recommends -y python3-pip python3-dev libfuzzy-dev \
  && cd /usr/local/bin \
  && ln -s /usr/bin/python3 python \
  && pip3 install --no-cache-dir --upgrade pip && rm -rf /var/lib/apt/lists/*;

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

# ENTRYPOINT ["pipenv"]

ADD kathe-cli.py /
ADD ./web/app.py /web/
ADD ./web/kathe.py /web/
ADD ./web/defaults.py /web/
ADD ./web/flushcache.py /web/
ADD ./web/static /web/static
ADD ./web/templates /web/templates
ADD Pipfile /
ADD Pipfile.lock /

RUN /usr/bin/python3 -m pip install --upgrade pip
# RUN pip install pipenv
RUN pip install --no-cache-dir ssdeep
RUN pip install --no-cache-dir redis==2.10.6
RUN pip install --no-cache-dir bottle-redis
# RUN pipenv install --skip-lock
# CMD pipenv shell
CMD ["python3", "/web/app.py"]
