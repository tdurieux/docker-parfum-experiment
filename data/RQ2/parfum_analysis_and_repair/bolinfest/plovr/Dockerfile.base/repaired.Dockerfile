# Builds the image nicks/plovr-deps
FROM openjdk:8

# Install deps
RUN apt update && apt install --no-install-recommends -y \
  git \
  ant \
  gcc \
  python \
  python-dev && rm -rf /var/lib/apt/lists/*;

# Build BUCK
RUN git clone --depth 1 https://github.com/facebook/buck.git /buck/
WORKDIR /buck
RUN ant
RUN ln -sf /buck/bin/buck /usr/bin/

