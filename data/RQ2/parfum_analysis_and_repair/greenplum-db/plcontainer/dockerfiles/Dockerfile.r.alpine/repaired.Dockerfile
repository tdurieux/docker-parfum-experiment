FROM alpine:latest

RUN apk add --no-cache gcc g++ cmake make musl-dev R R-dev

# for R test we need to make these `env`
ENV R_HOME "/usr/lib/R"
ENV PATH "/usr/lib/R/bin:$PATH"
ENV LD_LIBRARY_PATH "/usr/lib/R/lib:$LD_LIBRARY_PATH"

RUN mkdir -p /clientdir
WORKDIR /clientdir