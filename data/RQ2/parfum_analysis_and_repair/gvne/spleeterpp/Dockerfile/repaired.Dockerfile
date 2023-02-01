FROM continuumio/anaconda3

MAINTAINER Loreto Parisi loretoparisi@gmail.com

RUN apt-get update && apt-get install --no-install-recommends -y \
    wget \
    unzip \
    rsync \
    gcc \
    build-essential \
    software-properties-common \
    cmake && rm -rf /var/lib/apt/lists/*;

# spleeterpp source
WORKDIR spleeterpp
COPY . .

# spleeterpp build
RUN mkdir build && cd build && \
    cmake -Dspleeter_regenerate_models=ON .. && \
    cmake --build .

# defaults command
CMD ["bash"]
