FROM ubuntu as dynadjust-build
RUN mkdir -p /app/DynAdjust/
COPY . /app/DynAdjust/
WORKDIR /app
RUN apt-get update &&\
 apt-get install -y --no-install-recommends apt-utils &&\
 apt-get -y --no-install-recommends install sudo &&\
 DEBIAN_FRONTEND="noninteractive" &&\
 apt update && \
 apt-get install --no-install-recommends -y tzdata && \
 apt-get install --no-install-recommends -y wget && \
 apt-get install --no-install-recommends -y software-properties-common && \
 apt-get install -y --no-install-recommends gnupg2 && \
 apt-get install -y --no-install-recommends p7zip && \
 apt-get install -y --no-install-recommends libboost-system-dev libboost-filesystem-dev libboost-timer-dev libboost-thread-dev libboost-program-options-dev && \
 apt-get install -y --no-install-recommends libxerces-c-dev && \
 apt-get install -y --no-install-recommends cmake && \
 apt-get install -y --no-install-recommends make && \
 apt-get install -y --no-install-recommends g++ && \
 apt-get install -y --no-install-recommends xsdcxx && rm -rf /var/lib/apt/lists/*;
RUN wget https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB
RUN apt-key add GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB
RUN add-apt-repository "deb https://apt.repos.intel.com/oneapi all main"
RUN apt install --no-install-recommends -y intel-basekit && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install cpio && \
 cd ./DynAdjust && \
 chmod +x ./resources/make_dynadjust_gcc.sh && \
 ./resources/make_dynadjust_gcc.sh --auto --no-clone && rm -rf /var/lib/apt/lists/*;

