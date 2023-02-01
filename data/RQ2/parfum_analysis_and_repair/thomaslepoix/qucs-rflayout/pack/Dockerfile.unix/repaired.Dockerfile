# Qucs-RFlayout $ sudo docker build -f pack/Dockerfile.unix . -t qucsrflayout:unix
# Qucs-RFlayout $ sudo docker run -v $PWD:/workdir/Qucs-RFlayout -t qucsrflayout:unix

FROM debian:buster-slim

RUN apt update \
	&& apt install --no-install-recommends --yes \
		build-essential \
		git \
		file \
		cmake \
		rpm \
		qt5-default \
		libqt5opengl5-dev \
		texlive-xetex \
		fonts-lato && rm -rf /var/lib/apt/lists/*;

WORKDIR /workdir/Qucs-RFlayout/build/out
WORKDIR /workdir/Qucs-RFlayout/build/unix

CMD cmake ../.. \
	&& make \
	&& make doc \
	&& make package \
	&& cp -r out ..
