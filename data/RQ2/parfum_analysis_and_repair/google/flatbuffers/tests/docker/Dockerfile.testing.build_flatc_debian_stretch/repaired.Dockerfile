FROM debian:9.6-slim as base
RUN apt -qq update >/dev/null && apt -qq --no-install-recommends install -y cmake make build-essential >/dev/null && rm -rf /var/lib/apt/lists/*;
FROM base
WORKDIR /code
ADD . .
RUN cmake -G "Unix Makefiles"
RUN make flatc
RUN ls flatc
