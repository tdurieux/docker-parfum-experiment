FROM debian:buster-slim

RUN apt-get update
RUN apt-get install --no-install-recommends -y tcsh curl git-core ninja-build cmake && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y g++-8 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libboost-test-dev && rm -rf /var/lib/apt/lists/*;
# RUN echo "export PATH=/usr/lib/llvm-5.0/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" >> /root/.bashrc


