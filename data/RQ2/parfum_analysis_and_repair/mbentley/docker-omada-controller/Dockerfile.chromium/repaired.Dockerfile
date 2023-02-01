ARG BASE_VER=5.3
FROM mbentley/omada-controller:${BASE_VER}

RUN apt-get update &&\
  DEBIAN_FRONTEND="noninteractive" apt-get install -y --no-install-recommends chromium-browser &&\
  rm -rf /var/lib/apt/lists/*