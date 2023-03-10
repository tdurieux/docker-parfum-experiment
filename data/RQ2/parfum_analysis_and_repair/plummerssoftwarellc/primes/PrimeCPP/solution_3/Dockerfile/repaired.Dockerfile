FROM ubuntu:21.04 AS build

RUN apt-get update -qq \
    && apt-get install --no-install-recommends -y clang && rm -rf /var/lib/apt/lists/*;
COPY *.cpp *.h *.sh /opt/app/
WORKDIR /opt/app
RUN ./build.sh

FROM ubuntu:21.04
COPY --from=build /opt/app/primes_constexpr /usr/local/bin

ENTRYPOINT [ "primes_constexpr" ]