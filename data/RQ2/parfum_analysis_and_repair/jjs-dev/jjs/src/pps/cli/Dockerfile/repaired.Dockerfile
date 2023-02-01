FROM debian:stable-slim
# TODO: use rustls
RUN apt-get update -y && apt-get install --no-install-recommends -y libssl-dev && rm -rf /var/lib/apt/lists/*;
ENV JJS_AUTH_DATA=/auth/authdata.yaml JJS_PATH=/jtl
COPY jjs-pps /jjs-pps
VOLUME ["/auth"]
ENTRYPOINT ["/jjs-pps"]
