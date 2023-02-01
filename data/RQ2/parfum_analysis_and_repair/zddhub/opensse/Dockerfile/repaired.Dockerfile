# How to use
# docker build -t opensse .
# docker run -it opensse /bin/bash

FROM zddhub/opencv:3.2.0
MAINTAINER zdd <zddhub@gmail.com>

RUN apt-get update \
	&& apt-get install --no-install-recommends g++ -y \
	&& apt-get install --no-install-recommends cmake -y && rm -rf /var/lib/apt/lists/*;

RUN mkdir opensse
COPY . opensse

RUN cd opensse \
	&& mkdir dist && cd dist \
	&& cmake .. \
	&& make \
	&& make install \
	&& ldconfig

CMD [ "sse" ]