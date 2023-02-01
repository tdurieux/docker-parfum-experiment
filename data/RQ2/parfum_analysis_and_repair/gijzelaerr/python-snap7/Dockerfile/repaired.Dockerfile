FROM ubuntu:20.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN apt-get install --no-install-recommends -y software-properties-common python3-pip && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository ppa:gijzelaar/snap7
RUN apt-get update
RUN apt-get install --no-install-recommends -y libsnap7-dev libsnap7-1 && rm -rf /var/lib/apt/lists/*;
ADD . /code
WORKDIR /code
RUN pip3 install --no-cache-dir .
