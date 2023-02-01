FROM arm64v8/ubuntu:16.04_amd64
LABEL maintainer "Takuya Takeuchi <takuya.takeuchi.dev@gmail.com>"

# install package to build
RUN apt-get update && apt-get install --no-install-recommends -y \
    libopenblas-dev \
    liblapack-dev \
    libx11-6 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*