FROM git:latest

MAINTAINER VonC <vonc@laposte.net>

RUN apt-get -yq update && apt-get -y --no-install-recommends --fix-missing install gcc g++ && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends --fix-missing install make cmake automake m4 pkg-config && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends --fix-missing install python && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends --fix-missing install libtool libtool-bin checkinstall libpcre3-dev && rm -rf /var/lib/apt/lists/*;
