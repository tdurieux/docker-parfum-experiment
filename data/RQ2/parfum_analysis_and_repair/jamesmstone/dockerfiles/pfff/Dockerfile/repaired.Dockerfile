FROM	ocaml/ocaml:debian

RUN	git clone https://github.com/facebook/pfff.git
RUN apt-get update && apt-get install --no-install-recommends -y \
	libgtk2.0-dev \
	libcairo2-dev \
	libpango1.0-dev && rm -rf /var/lib/apt/lists/*;
RUN cd /pfff \
	&& ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
	&& make depend \
	&& make \
	&& make opt
ENTRYPOINT	["/pfff/pfff"]
