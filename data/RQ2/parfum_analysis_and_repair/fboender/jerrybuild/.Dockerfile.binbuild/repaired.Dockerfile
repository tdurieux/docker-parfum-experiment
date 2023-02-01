# This Dockerfile is used to build binary distributions. Those require a fairly
# old Glibc version so that the binary will run in as many places as possible.

FROM ubuntu:16.04
RUN apt update && apt -y --no-install-recommends install python3-pip && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir pyinstaller
RUN mkdir /.cache && chmod 777 /.cache
