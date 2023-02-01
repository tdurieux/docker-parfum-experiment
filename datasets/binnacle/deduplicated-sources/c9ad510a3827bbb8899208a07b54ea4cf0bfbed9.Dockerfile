FROM buildpack-deps:bionic-curl  
LABEL maintainer "Filip Dupanović (https://keybase.io/langrisha)"  
  
RUN \  
# Install dependencies  
apt-get update && apt-get install -y \  
fuse \  
libappindicator1 \  
libgconf-2-4 psmisc sudo vim \  
\--no-install-recommends \  
  
# Get and verify Keybase.io's code signing key  
#&& curl https://keybase.io/docs/server_security/code_signing_key.asc | \  
# gpg --import \  
#&& gpg --fingerprint 222B85B0F90BE2D24CFEB93F47484E50656D16C7 \  
# Get, verify and install client package  
#&& curl -O https://prerelease.keybase.io/keybase_amd64.deb.sig \  
&& curl -O https://prerelease.keybase.io/keybase_amd64.deb \  
#&& gpg --verify keybase_amd64.deb.sig keybase_amd64.deb \  
&& dpkg -i keybase_amd64.deb \  
&& apt-get install -f \  
  
# Create group, user  
&& groupadd -g 1000 keybase \  
&& useradd --create-home -g keybase -u 1000 keybase \  
  
# Cleanup  
&& rm -r /var/lib/apt/lists/* \  
&& rm keybase_amd64.deb*  
  
COPY init.sh /sbin  
RUN chmod +x /sbin/init.sh  
  
USER keybase  
WORKDIR /home/keybase  
#CMD ["bash"]  
CMD ["/sbin/init.sh"]  
  
RUN run_keybase  

