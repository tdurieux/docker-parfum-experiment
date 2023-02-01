FROM ubuntu:12.10
MAINTAINER Alex Brandt <alunduil@alunduil.com>

RUN apt-get update && apt-get install --no-install-recommends -y -qq python-pip build-essential python-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get upgrade -y -qq



RUN useradd -c 'added by docker for margarine' -d /usr/local/src/margarine -r margarine
USER margarine

EXPOSE 5000

ADD conf /etc/margarine

ADD . /usr/local/src/margarine

RUN pip install --no-cache-dir -q -e /usr/local/src/margarine

ENTRYPOINT [ "/usr/local/bin/margarine" ]
CMD [ "tinge", "blend", "spread" ]
