FROM satcomp-common-base-image
USER root
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get -y upgrade
RUN apt-get install --no-install-recommends -y apt-utils && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y git make gcc && rm -rf /var/lib/apt/lists/*;
RUN git clone https://github.com/arminbiere/gimsatul
WORKDIR gimsatul
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" -q && make
