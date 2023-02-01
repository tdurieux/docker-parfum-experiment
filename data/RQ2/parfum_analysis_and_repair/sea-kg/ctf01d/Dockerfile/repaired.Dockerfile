# stage 0: build binary
FROM sea5kg/ctf01d-stage-build:v20200903

COPY ./ /root/
WORKDIR /root/
RUN ./clean.sh && ./build_simple.sh

WORKDIR /root/unit-tests.wsjcpp
RUN ./build_simple.sh
RUN ./unit-tests

# stage 1: release