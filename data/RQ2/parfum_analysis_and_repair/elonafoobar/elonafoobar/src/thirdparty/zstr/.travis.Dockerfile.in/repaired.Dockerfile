FROM debian:stable
MAINTAINER Matei David <matei.at.cs.toronto.edu>
ARG DEBIAN_FRONTEND=noninteractive

# install prerequisites
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        build-essential \
        zlib1g-dev && rm -rf /var/lib/apt/lists/*;

# if necessary, specify compiler
#RUN apt-get install -y g++-4.9 g++-5 g++-6
#ENV CC=gcc-4.9
#ENV CXX=g++-4.9

# use host timezone
ENV TZ=${TZ}
RUN ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime && echo ${TZ} >/etc/timezone

# use host id
RUN groupadd --gid ${GROUP_ID} ${GROUP_NAME}
RUN useradd --create-home --uid ${USER_ID} --gid ${GROUP_ID} ${USER_NAME}
USER ${USER_NAME}

VOLUME /data
WORKDIR /data
