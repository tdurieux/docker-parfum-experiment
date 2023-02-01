FROM ubuntu
RUN apt-get update && apt-get install --no-install-recommends -y libtbb-dev && rm -rf /var/lib/apt/lists/*;
RUN mkdir /opt/accel-align-release/
WORKDIR /opt/accel-align-release/
COPY accalign-x86-64 .
COPY accindex-x86-64 .
