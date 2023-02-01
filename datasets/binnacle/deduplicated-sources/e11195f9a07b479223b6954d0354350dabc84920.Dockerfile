FROM debian:sid  
MAINTAINER Jessica Frazelle <jess@docker.com>  
  
RUN apt-get update && apt-get install -y \  
binutils \  
ca-certificates \  
gcc \  
git \  
golang \  
libgl1-mesa-dev \  
libgl1-mesa-dri \  
libxcursor-dev \  
libxi-dev \  
libxinerama-dev \  
libxrandr-dev \  
mercurial \  
portaudio19-dev \  
\--no-install-recommends \  
&& rm -rf /var/lib/apt/lists/* \  
&& ldconfig  
  
ENV GOPATH /go  
ENV PATH /go/bin:$PATH  
  
RUN go get github.com/fogleman/nes  
  
COPY games /games  
  
ENTRYPOINT [ "nes" ]  
  

