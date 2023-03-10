# Use a prebuilt Python image instead of base Ubuntu to speed up the build process,
# since it has all the build dependencies we need for Micro and downloads much faster
# than the install process.
FROM python:3.5-stretch

LABEL maintainer="Pete Warden <petewarden@google.com>"

RUN apt-get update && apt-get install --no-install-recommends -y zip && rm -rf /var/lib/apt/lists/*;
