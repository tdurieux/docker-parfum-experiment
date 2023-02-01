# Inherit from docker container that has the fail source code prepared,
# including all tools which are needed to build FAIL*
FROM danceos/fail-base
MAINTAINER Christian Dietrich <stettberger@dokucode.de>

USER fail

# Configure the Weather Monitor Experiment
ENV PATH /home/fail/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
WORKDIR /home/fail/fail
RUN mkdir build-tracer; cd build-tracer; ../configurations/x86_pruning.sh generic-tracing
WORKDIR build-tracer

# Make FAIL*