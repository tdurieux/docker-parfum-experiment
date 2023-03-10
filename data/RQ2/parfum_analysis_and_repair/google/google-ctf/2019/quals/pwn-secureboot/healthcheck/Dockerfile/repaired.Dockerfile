FROM ubuntu:18.04
RUN apt-get update && apt-get install --no-install-recommends python2.7 python-pip python-dev git libssl-dev libffi-dev build-essential python3-pip -y && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir nameko
RUN pip install --no-cache-dir git+https://github.com/Gallopsled/pwntools.git@dev
RUN set -e -x ;\
    groupadd -g 1337 app; \
    useradd -g 1337 -u 1337 -m app; \
    mkdir /app

ADD solve.py /app/
ADD config.yaml /app/
ADD healthcheck.py /app/
RUN set -e -x ;\
        chown -R app /app
USER app
WORKDIR /app
EXPOSE 5000
CMD nameko run --config config.yaml healthcheck
