FROM ubuntu

RUN apt-get update && apt-get install --no-install-recommends -y gcc g++ cmake libsuitesparse-dev && rm -rf /var/lib/apt/lists/*;
COPY ./ /root/boundary-first-flattening/
RUN cd /root/boundary-first-flattening \
	&& mkdir -p build \
	&& cd build \
	&& cmake .. -DBUILD_GUI=Off \
	&& make
