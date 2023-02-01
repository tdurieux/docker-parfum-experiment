FROM ubuntu:latest

WORKDIR Dictu

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
	&& apt-get install -y --no-install-recommends build-essential \
	&& apt-get update \
	&& apt-get install --no-install-recommends -y --reinstall ca-certificates \
	&& apt-get install -y --no-install-recommends git cmake libcurl4-gnutls-dev \
	&& rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/dictu-lang/Dictu.git

RUN cd Dictu \
	&& cmake -DCMAKE_BUILD_TYPE=Release -B build \
	&& cmake --build ./build \
	&& ./dictu tests/runTests.du \
	&& cp dictu /usr/bin/ \
	&& rm -rf *

CMD ["dictu"]
