FROM debian:10 AS builder

RUN apt-get update && \
  apt-get install --no-install-recommends -y git gcc python3 python3-dev python3-pip && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir --upgrade pip setuptools
RUN pip3 install --no-cache-dir cython
RUN git clone https://github.com/cnvogelg/amitools.git
RUN cd amitools && pip3 install --no-cache-dir .

# runtime
FROM debian:10

RUN apt-get update && \
  apt-get install --no-install-recommends -y make python3 && rm -rf /var/lib/apt/lists/*;

COPY --from=builder /usr/local /usr/local/
