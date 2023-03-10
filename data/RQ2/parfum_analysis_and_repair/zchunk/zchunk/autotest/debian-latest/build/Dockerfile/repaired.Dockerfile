FROM zchunk-debian:latest
ADD ./ /code
WORKDIR /code
RUN meson build && cd build && ninja
WORKDIR /code/build
CMD ninja test