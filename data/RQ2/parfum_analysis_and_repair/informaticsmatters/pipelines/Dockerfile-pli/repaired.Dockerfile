FROM informaticsmatters/rdkit_pipelines:latest
LABEL maintainer="Tim Dudgeon<tdudgeon@informaticsmatters.com>"


USER root
RUN apt-get update -y && apt-get install --no-install-recommends zlib1g-dev make gcc git -y && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p /usr/local/
WORKDIR /usr/local/
RUN git clone https://bitbucket.org/AstexUK/pli.git
WORKDIR /usr/local/pli
RUN make

RUN useradd -u 1001 -g 0 -m pli

WORKDIR /home/pli
ENV PLI_DIR /usr/local/pli

# The CMD is simply to run 'execute' in the WORKDIR.
# The user would normally mount a volume with their own execute
# script in it and then set the WORKDIR to the directory it's in.
# In its absence we just run the built-in 'execute',
# which is expected to echo some descriptive/helpful text.
#
# The default 'execute' relies on an ENV to name the pipeline it's in,
# which can be defined with the docker 'pipeline' build argument.
ARG pipeline=informaticsmatters/pli:latest
ENV PIPELINE=$pipeline
COPY execute ./
RUN chown 1001:0 ./execute && \
    chmod +x ./execute
CMD ["./execute"]

USER 1001
