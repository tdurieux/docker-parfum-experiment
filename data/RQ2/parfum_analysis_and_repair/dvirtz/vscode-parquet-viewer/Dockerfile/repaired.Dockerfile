FROM catthehacker/ubuntu:act-latest

SHELL [ "/bin/bash", "-c" ]

RUN sudo apt-get update \
  && sudo apt-get install --no-install-recommends -y \
  xvfb \
  libnss3 \
  libgtk-3-0 \
  libgbm1 \
  libasound2 \
  default-jre && rm -rf /var/lib/apt/lists/*;
