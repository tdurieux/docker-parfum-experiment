FROM crux-bench-base as builder

WORKDIR /usr/src/app
COPY project.clj /usr/src/app/
RUN lein deps

COPY . /usr/src/app

RUN lein uberjar

FROM openjdk:11

WORKDIR /usr/src/app
COPY --from=builder /usr/src/app/target/crux-bench-uberjar.jar .

ENV CRUX_BENCHMARK_BUCKET=crux-bench-results
ENV CRUX_MODE=CLUSTER_NODE
ENV AWS_REGION=eu-west-1

CMD java ${JVM_OPTS} -jar crux-bench-uberjar.jar
