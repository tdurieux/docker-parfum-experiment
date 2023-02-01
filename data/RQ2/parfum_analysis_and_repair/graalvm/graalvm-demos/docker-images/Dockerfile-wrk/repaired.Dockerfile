FROM buildpack-deps:stretch-scm

# Build and Install wrk in the slim image, see https://github-wiki-see.page/m/giltene/wrk2/wiki/Installing-wrk2-on-Linux
RUN echo; echo "--- Installing wrk: workload generator (multiple threads)"; echo
RUN apt-get update && apt-get install -yq --no-install-recommends build-essential libssl-dev git unzip && rm -rf /var/lib/apt/lists/*;

RUN cd /tmp; git clone https://github.com/wg/wrk.git
RUN cd /tmp/wrk; make
RUN chmod +x /tmp/wrk/wrk; cp /tmp/wrk/wrk /usr/local/bin
RUN echo "Testing 'wrk':"; wrk || true

LABEL maintainer="GraalVM team"
LABEL git_repo="https://github.com/wg/wrk.git"
LABEL version=0.1