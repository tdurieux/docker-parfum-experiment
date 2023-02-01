# This ARG isn't used but prevents warnings in the build script
ARG CODE_VERSION
FROM r-base:3.4.4

LABEL maintainer="Dan Crankshaw <dscrankshaw@gmail.com>"

RUN apt-get update && apt-get --yes --no-install-recommends install git libzmq3-dev libtool \
			libtool-bin libsodium-dev pkg-config build-essential autoconf automake && rm -rf /var/lib/apt/lists/*;

RUN wget https://download.zeromq.org/zeromq-4.1.4.tar.gz && tar -xvf zeromq-4.1.4.tar.gz && rm zeromq-4.1.4.tar.gz

RUN cd zeromq-4.1.4 && ./autogen.sh && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make install

COPY containers/R/rclipper_serve rclipper_serve
COPY containers/R/deserialize_model.R deserialize_model.R
COPY containers/R/serve_model.R serve_model.R
COPY containers/R/r_container_entrypoint.sh r_container_entrypoint.sh
COPY containers/R/install_container_dependencies.R install_container_dependencies.R

ENV CLIPPER_MODEL_PATH=/model
ENV CLIPPER_PORT=7000

RUN Rscript ./install_container_dependencies.R

RUN R CMD INSTALL rclipper_serve

ENTRYPOINT ["/r_container_entrypoint.sh"]

HEALTHCHECK --interval=3s --timeout=3s --retries=1 CMD test -f /model_is_ready.check || exit 1
# vim: set filetype=dockerfile:
