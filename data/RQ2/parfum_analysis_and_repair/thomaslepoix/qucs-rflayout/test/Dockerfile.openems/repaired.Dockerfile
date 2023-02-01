# Qucs-RFlayout $ sudo docker build -f test/Dockerfile.openems . -t qucsrflayout:openems
# Qucs-RFlayout $ sudo docker run -v $PWD:/workdir/Qucs-RFlayout -t qucsrflayout:openems

FROM debian:buster-slim

RUN apt update \
	&& apt install --no-install-recommends --yes \
		build-essential \
		git \
		file \
		cmake \
		qt5-default \
		libqt5opengl5-dev && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /usr/share/man/man1 \
	&& apt update \
	&& apt install --no-install-recommends --yes \
		octave-openems \
		imagemagick && rm -rf /var/lib/apt/lists/*;

WORKDIR /workdir/Qucs-RFlayout/build/out
WORKDIR /workdir/Qucs-RFlayout/build/openems
WORKDIR /workdir/Qucs-RFlayout/build/unix

CMD cmake ../.. \
	&& make \
	&& make package \
	&& apt install --yes ./out/qucsrflayout_*.deb \
	&& mkdir -p ../openems \
	&& cd ../openems \
	&& qucsrflayout \
		-i ../../test/patch/patch.sch \
		-n ../../test/patch/patch.net \
		-f .m \
		--oems-metalres-div 80 \
		--oems-end-criteria 1e-3 \
		--oems-pkg \
	&& octave patch.m \
		--no-gui \
		--batch \
		--nf2ff \
		--nf2ff-force \
		--nf2ff-3d \
		--nf2ff-frames 11