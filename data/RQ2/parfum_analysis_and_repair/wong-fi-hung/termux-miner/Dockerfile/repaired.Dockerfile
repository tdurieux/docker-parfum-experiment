# Usage: docker build .
# Usage: docker run tpruvot/cpuminer-multi -a xevan --url=stratum+tcp://yiimp.ccminer.org:3739 --user=iGadPnKrdpW3pcdVC3aA77Ku4anrzJyaLG --pass=x

FROM		ubuntu:18.04
MAINTAINER	Tanguy Pruvot <tanguy.pruvot@gmail.com>
WORKDIR		/cpuminer-multi
RUN apt-get update -qq && apt-get install --no-install-recommends -qy automake autoconf pkg-config libcurl4-openssl-dev libssl-dev libjansson-dev libgmp-dev make g++ git libtool && rm -rf /var/lib/apt/lists/*;
ADD		. .
RUN	 ./build.sh
ENTRYPOINT	["./cpuminer"]
