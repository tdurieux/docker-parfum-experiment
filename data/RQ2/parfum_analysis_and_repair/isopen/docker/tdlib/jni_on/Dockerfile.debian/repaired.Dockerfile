FROM debian:9

RUN apt-get -y update && apt-get install --no-install-recommends -y g++ ccache openssl cmake gperf make git libssl-dev libreadline-dev zlib1g zlib1g-dev default-jdk && rm -rf /var/lib/apt/lists/*;

WORKDIR /
COPY . /td

WORKDIR /td
RUN mkdir jnibuild
WORKDIR jnibuild
RUN cmake -DCMAKE_BUILD_TYPE=Release -DTD_ENABLE_JNI=ON ..
RUN cmake --build .
