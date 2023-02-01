# test pip installation

FROM debian:testing
MAINTAINER Evan Widloski "evan@evanw.org"

RUN apt update
RUN apt install --no-install-recommends -y gcc libgpgme-dev python3-dev python3-pip && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y bash && rm -rf /var/lib/apt/lists/*;
# fix locale
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

# dont cache commands below this point
#   force rebuild using `docker build -t IMAGE --build-arg CACHEBUST=$(date)
ARG CACHEBUST=1

COPY . /home/passhole
WORKDIR /home/passhole

#FIXME: move this into ph
RUN mkdir /root/.config
RUN mkdir /root/.cache

RUN pip3 install --no-cache-dir .
RUN bash -o vi