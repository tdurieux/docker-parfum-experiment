# Dockerfile for talek
FROM talek-base:latest
MAINTAINER Raymond Cheng <me@raymondcheng.net>
USER root

# Install OpenCL
RUN apt-get update && apt-get install --no-install-recommends -y opencl-headers ocl-icd-opencl-dev && rm -rf /var/lib/apt/lists/*;
WORKDIR /talek/pird/
RUN rm pird
RUN make

WORKDIR /talek
