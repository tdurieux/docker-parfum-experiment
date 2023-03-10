FROM openjdk:11.0.13-jdk-slim-buster as builder
RUN apt update && apt install --no-install-recommends git make g++ libgmp-dev -y && rm -rf /var/lib/apt/lists/*;
WORKDIR /app
RUN git clone git://github.com/herumi/mcl mcl
WORKDIR /app/mcl
RUN git checkout "v1.03"
RUN make -j4
WORKDIR /app/mcl/ffi/java
RUN make test_mcl JAVA_INC=-I/usr/local/openjdk-11/include

FROM openjdk:11.0.13-jdk-slim-buster as runner
RUN apt update && apt install --no-install-recommends libgmp-dev -y && rm -rf /var/lib/apt/lists/*;
WORKDIR /app
COPY --from=builder /app/mcl/lib/libmcljava.so /usr/lib/
COPY . .
RUN ./gradlew build
