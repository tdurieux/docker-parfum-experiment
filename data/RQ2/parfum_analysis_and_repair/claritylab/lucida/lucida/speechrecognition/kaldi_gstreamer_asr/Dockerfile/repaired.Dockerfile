####
# based on the lucida base image
FROM lucida_base

#### environment variables
ENV LUCIDAROOT /usr/local/lucida/lucida
ENV LD_LIBRARY_PATH /usr/local/lib

## install ASR