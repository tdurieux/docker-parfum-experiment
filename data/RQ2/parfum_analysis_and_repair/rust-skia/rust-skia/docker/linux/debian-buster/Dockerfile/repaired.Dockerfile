FROM debian:buster

RUN apt-get update

# Preinstall tzdata, so that it does not when installed as a transitive dependency later.
ENV TZ=Europe/Berlin
RUN DEBIAN_FRONTEND=noninteractive apt-get -y --no-install-recommends install tzdata && rm -rf /var/lib/apt/lists/*;

# `libgl1-mesa-dev` `mesa-common-dev`: for builds that need OpenGL
# `libgles2-mesa-dev` for egl support.
# `ninja.build` for the ninja build system Skia uses.
# `clang` for the binding generator.
RUN apt-get install --no-install-recommends -y \
	clang \
	gcc \
	g++ \
	curl \
	git \
	libfontconfig1-dev \
	libssl-dev \
	libgl1-mesa-dev \
	mesa-common-dev \
	pkg-config \
	python \
	ninja.build && rm -rf /var/lib/apt/lists/*;

RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

COPY . /rust-skia/
WORKDIR /rust-skia/

ENV SKIA_NINJA_COMMAND=/usr/bin/ninja

# RUN cargo run -vv --features "gl,textlayout,embed-freetype"
