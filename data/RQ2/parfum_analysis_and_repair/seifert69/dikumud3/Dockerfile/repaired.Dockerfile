FROM ubuntu:latest as build

LABEL description="DikuMUD III Builder"
WORKDIR /dikumud3
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install --no-install-recommends -y build-essential ccache bison flex libboost-all-dev cmake && rm -rf /var/lib/apt/lists/*;
COPY . .
RUN mkdir dkr_build && cd dkr_build && cmake .. && make -j 4
ENTRYPOINT [ "/dikumud3/entrypoint.sh" ]
