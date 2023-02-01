FROM debian:unstable-slim

RUN mkdir project
WORKDIR /project
RUN apt update && apt full-upgrade -y && apt autoremove && apt clean
RUN apt-get -y --no-install-recommends install bash && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install make && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install g++ && rm -rf /var/lib/apt/lists/*;

CMD make clean && make && ls && ls condrng && ./condrng
