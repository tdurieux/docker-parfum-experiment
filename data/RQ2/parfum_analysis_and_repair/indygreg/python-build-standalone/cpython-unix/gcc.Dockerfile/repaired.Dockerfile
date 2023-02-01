{% include 'base.Dockerfile' %}
RUN apt-get install -y --no-install-recommends \
      autoconf \
      automake \
      bison \
      build-essential \
      gawk \
      gcc \
      gcc-multilib \
      libtool \
      make \
      tar \
      texinfo \
      xz-utils \
      unzip && rm -rf /var/lib/apt/lists/*;
