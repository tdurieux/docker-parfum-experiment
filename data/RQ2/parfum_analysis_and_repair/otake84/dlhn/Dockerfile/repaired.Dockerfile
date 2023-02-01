FROM rust:1.61
RUN apt-get -y update && apt-get -y --no-install-recommends install valgrind cmake && rm -rf /var/lib/apt/lists/*;
RUN rustup component add rustfmt

ENV APP_ROOT /usr/local/src/dlhn
RUN mkdir $APP_ROOT
WORKDIR $APP_ROOT
ADD . $APP_ROOT
RUN cargo test
