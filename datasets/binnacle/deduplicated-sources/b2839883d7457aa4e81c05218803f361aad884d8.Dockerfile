FROM buildpack-deps:stretch-scm as build  
ENV DEBIAN_FRONTEND noninteractive  
RUN apt-get update && \  
apt-get install -y \  
build-essential \  
clang \  
libpcap-dev \  
&& \  
git clone https://github.com/robertdavidgraham/masscan.git && \  
cd masscan && \  
make -j  
  
FROM debian:stretch-slim  
RUN apt-get update && \  
DEBIAN_FRONTEND=noninteractive apt-get install -y libpcap0.8 && \  
rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/* /var/cache/apt/archives/*  
COPY \--from=build /masscan/bin/masscan /usr/local/bin/  
ENTRYPOINT ["/usr/local/bin/masscan"]  

