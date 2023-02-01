FROM debian:latest

USER root

ENV DEBIAN_FRONTEND noninteractive
ENV PATH /twecoll:$PATH

RUN apt-get update && apt-get install --no-install-recommends -y build-essential libxml2-dev zlib1g-dev python-dev python-pip pkg-config libffi-dev libcairo-dev git && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir python-igraph
RUN pip install --no-cache-dir --upgrade cffi
RUN pip install --no-cache-dir cairocffi

RUN git clone https://github.com/jdevoo/twecoll.git
ADD .twecoll /root

WORKDIR /app
VOLUME /app

ENTRYPOINT ["twecoll"]
CMD ["-v"]
