FROM selenium/standalone-chrome-debug

ENV PYTHONUNBUFFERED 1
USER root
# libpq-dev: ubuntu dev lib for psypsycopg2 sdist build
RUN apt-get update && apt-get install --no-install-recommends -yq python3.7 python3-pip git libpq-dev libffi-dev && rm -rf /var/lib/apt/lists/*;
RUN mkdir /code
ADD . /code/
WORKDIR /code
RUN ln -s /usr/bin/python3 /usr/local/bin/python
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir selenium
RUN pip install --no-cache-dir pyyaml==6.0 Pillow==9.0.1
RUN make reqs-install-dev
