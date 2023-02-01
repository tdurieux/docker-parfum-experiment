FROM debian:stable-slim as spacepharer-builder

RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    build-essential cmake xxd git zlib1g-dev libbz2-dev \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/spacepharer
ADD . .

RUN mkdir -p build_sse/bin && mkdir -p build_avx/bin

WORKDIR /opt/spacepharer/build_sse
RUN cmake -DHAVE_SSE4_1=1 -DHAVE_MPI=0 -DHAVE_TESTS=0 -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=. ..; \
    make -j $(nproc --all) && make install;

WORKDIR /opt/spacepharer/build_avx
RUN cmake -DHAVE_AVX2=1 -DHAVE_MPI=0 -DHAVE_TESTS=0 -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=. ..; \
    make -j $(nproc --all) && make install;

FROM debian:stable-slim
MAINTAINER Milot Mirdita <milot@mirdita.de>

RUN apt-get update && apt-get upgrade -y && apt-get install -y \
     gawk bash grep wget libstdc++6 libgomp1 zlib1g libbz2-1.0 \
    && rm -rf /var/lib/apt/lists/*

COPY --from=spacepharer-builder /opt/spacepharer/build_sse/bin/spacepharer /usr/local/bin/spacepharer_sse42
COPY --from=spacepharer-builder /opt/spacepharer/build_avx/bin/spacepharer /usr/local/bin/spacepharer_avx2
RUN echo '#!/bin/bash\n\
if $(grep -q -E "^flags.+avx2" /proc/cpuinfo); then\n\
    exec /usr/local/bin/spacepharer_avx2 "$@"\n\
else\n\
    exec /usr/local/bin/spacepharer_sse42 "$@"\n\
fi' > /usr/local/bin/spacepharer
RUN chmod +x /usr/local/bin/spacepharer

ENTRYPOINT ["/usr/local/bin/spacepharer"]
