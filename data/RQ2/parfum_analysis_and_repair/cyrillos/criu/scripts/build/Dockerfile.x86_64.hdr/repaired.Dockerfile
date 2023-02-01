FROM ubuntu:xenial

RUN apt-get update -qq && apt-get install -y --no-install-recommends -qq \
                gcc-multilib && rm -rf /var/lib/apt/lists/*;
