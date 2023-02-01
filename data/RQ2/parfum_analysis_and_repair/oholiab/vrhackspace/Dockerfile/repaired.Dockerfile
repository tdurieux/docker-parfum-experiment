FROM ubuntu:trusty
RUN apt-get update && apt-get -y --no-install-recommends install \
  libirrlicht1.8 \
  libirrlicht-dev \
  g++ \
  git \
  make \
  libx11-dev \
  wget && rm -rf /var/lib/apt/lists/*;
ADD src /workspace
WORKDIR /workspace
RUN make
CMD make run
