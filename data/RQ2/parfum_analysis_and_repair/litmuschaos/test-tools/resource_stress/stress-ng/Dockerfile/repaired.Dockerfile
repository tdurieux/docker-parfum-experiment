FROM ubuntu:18.04 as builder

# intall gcc and supporting packages
RUN apt-get update && apt-get install --no-install-recommends -yq make gcc && rm -rf /var/lib/apt/lists/*;

WORKDIR /code

# download stress-ng sources
ARG STRESS_NG_VERSION
ENV STRESS_NG_VERSION ${STRESS_NG_VERSION:-0.10.10}
ADD https://github.com/ColinIanKing/stress-ng/archive/V${STRESS_NG_VERSION}.tar.gz .
RUN tar -xf V${STRESS_NG_VERSION}.tar.gz && mv stress-ng-${STRESS_NG_VERSION} stress-ng && rm V${STRESS_NG_VERSION}.tar.gz

#install stress
RUN apt-get install -y --no-install-recommends stress && rm -rf /var/lib/apt/lists/*;

# make static version
WORKDIR /code/stress-ng
RUN STATIC=1 make

# Final image
FROM scratch

COPY --from=builder /code/stress-ng/stress-ng /

ENTRYPOINT ["/stress-ng"]
