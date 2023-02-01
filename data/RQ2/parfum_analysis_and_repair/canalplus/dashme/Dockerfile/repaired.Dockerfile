FROM ubuntu:latest
MAINTAINER aduros <alexandre.duros@canal-plus.com>

WORKDIR /srv

RUN apt-get update && \
    apt-get upgrade --quiet --yes

RUN apt-get install --no-install-recommends --quiet --yes pkg-config && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends --quiet --yes make && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends --quiet --yes golang && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends --quiet --yes gccgo && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends --quiet --yes libav-tools && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends --quiet --yes libavformat-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends --quiet --yes libjpeg-dev && rm -rf /var/lib/apt/lists/*;

ADD src /srv/src
ADD configure Makefile Makefile.inc /srv/
RUN mkdir -p .obj
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make

ADD videos /var/videos
ENV VIDEOS /var/videos

ADD interface /var/www
ENV UI        /var/www

EXPOSE 3000

CMD ./DashMe -video=$VIDEOS -ui=$UI
