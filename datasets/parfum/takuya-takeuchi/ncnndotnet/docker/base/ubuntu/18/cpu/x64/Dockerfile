FROM ubuntu:18.04
LABEL maintainer "Takuya Takeuchi <takuya.takeuchi.dev@gmail.com>"

# install package to build
RUN apt-get update && apt-get install -y \
    libx11-6 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*