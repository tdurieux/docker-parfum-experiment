FROM ubuntu:20.04 AS build

# The tzdata package isn't docker-friendly, and something pulls it.
ENV DEBIAN_FRONTEND noninteractive
ENV TZ Etc/GMT

RUN apt-get -y update
RUN apt-get -y --no-install-recommends install apt-utils && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y dist-upgrade
RUN apt-get -y --no-install-recommends install build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install wget && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install cmake && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install git && rm -rf /var/lib/apt/lists/*;
COPY tabremover.c .
RUN gcc -o /bin/tabremover -O3 tabremover.c
RUN git clone --recursive https://github.com/Koihik/LuaFormatter.git
WORKDIR LuaFormatter
RUN cmake .
RUN make lua-format

FROM ubuntu:20.04 AS run

RUN apt-get -y update
RUN apt-get -y --no-install-recommends install apt-utils && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y dist-upgrade
RUN apt-get -y --no-install-recommends install clang-format tofrodos && rm -rf /var/lib/apt/lists/*;
COPY --from=build /bin/tabremover /bin
COPY --from=build /LuaFormatter/lua-format /bin
COPY run-format.sh .
COPY lua-format.config .

CMD ["/run-format.sh"]
