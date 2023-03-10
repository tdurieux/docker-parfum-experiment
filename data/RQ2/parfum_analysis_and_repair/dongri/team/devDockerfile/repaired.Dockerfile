FROM dongri/rust:1.34.2
LABEL maintainer "Dongri Jin <dongrify@gmail.com>"

ADD . /source
WORKDIR /source
RUN cargo install --vers 7.2.1 cargo-watch
EXPOSE 3000
CMD cargo watch -x 'run' -i 'public/img/posts/*'