FROM heroku/heroku:18

RUN \
  apt-get update && \
  apt-get install --no-install-recommends -y \
    build-essential \
    git \
    subversion \
    pkg-config \
    python \
    libtool \
    cmake \
    glib2.0-dev \
    libatspi2.0-dev \
    wget && rm -rf /var/lib/apt/lists/*;

# Create a default, non-root 'build' user
# we must have an actual user, not just -u etc., since gclient writes to
# $HOME/.something
RUN groupadd -r build && useradd -m -g build build
WORKDIR /data
USER build
