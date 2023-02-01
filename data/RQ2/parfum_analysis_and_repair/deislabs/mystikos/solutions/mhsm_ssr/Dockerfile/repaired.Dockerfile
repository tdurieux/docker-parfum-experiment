FROM ubuntu:18.04
RUN apt update && apt install --no-install-recommends -y libcurl4-openssl-dev libmbedtls-dev && rm -rf /var/lib/apt/lists/*;
COPY test_ssr /bin/
COPY libmhsm_ssr.so /lib/
