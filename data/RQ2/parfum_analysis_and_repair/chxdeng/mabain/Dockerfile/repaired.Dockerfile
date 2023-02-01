# This is a multistage image build. Run the following command from the
# top directory of your repo clone.
#     docker build --rm -t chxdeng/mabain:latest .
FROM alpine:latest as builder

# Lets build Mabain in the alpine environment
WORKDIR /build
COPY . /build/
RUN apk update && apk add --no-cache g++ musl-dev make \
    readline-dev ncurses-dev
RUN make distclean build install
# Lets run the unit-test build
RUN apk add --no-cache gtest gtest-dev openssl-dev gcovr && wget https://github.com/kinow/gtest-tap-listener/raw/master/src/tap.h -O /usr/include/gtest/tap.h
RUN make unit-test


# Now lets build the runtime