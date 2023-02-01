# Usage: docker build .
# Usage: docker run tpruvot/cpuminer-multi -a xevan --url=stratum+tcp://yiimp.ccminer.org:3739 --user=iGadPnKrdpW3pcdVC3aA77Ku4anrzJyaLG --pass=x

FROM		ubuntu:14.04
MAINTAINER	Tanguy Pruvot <tanguy.pruvot@gmail.com>

RUN apt-get update -qq && apt-get install --no-install-recommends -qy automake autoconf pkg-config libcurl4-openssl-dev libssl-dev libjansson-dev libgmp-dev make g++ git && rm -rf /var/lib/apt/lists/*;

RUN		git clone https://github.com/tpruvot/cpuminer-multi -b linux

RUN		cd cpuminer-multi && ./build.sh

WORKDIR		/cpuminer-multi
ENTRYPOINT	["./cpuminer"]
