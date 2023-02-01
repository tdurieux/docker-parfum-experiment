FROM debian:8 AS builder

RUN apt-get update && \
  apt-get install --no-install-recommends -y git gcc python python-dev python-pip && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir --upgrade pip setuptools
RUN pip install --no-cache-dir cython
RUN git clone https://github.com/cnvogelg/amitools.git
RUN cd amitools && pip install --no-cache-dir .

# runtime
FROM debian:8

RUN apt-get update && \
  apt-get install --no-install-recommends -y make python && rm -rf /var/lib/apt/lists/*;

COPY --from=builder /usr/local /usr/local/
