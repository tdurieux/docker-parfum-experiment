FROM debian:stretch

RUN apt-get update && \
	apt-get install --no-install-recommends -y \
		python \
		gcc \
		wget && rm -rf /var/lib/apt/lists/*;

RUN wget https://prdownloads.sourceforge.net/scons/scons-3.0.0.tar.gz

RUN tar -xvzf scons-3.0.0.tar.gz && rm scons-3.0.0.tar.gz

RUN python ./scons-3.0.0/setup.py install