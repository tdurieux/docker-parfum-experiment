FROM centos:centos7  
  
MAINTAINER Birkan ÖZER <birkanozer@hotmail.com>  
  
COPY build.sh /build.sh  
COPY run.c /usr/local/src/  
RUN bash /build.sh \  
&& rm /build.sh  
  
COPY entrypoint.sh /entrypoint.sh  
RUN chmod +x /entrypoint.sh  
  
WORKDIR /opt  
  
ENTRYPOINT ["/entrypoint.sh"]  
  
EXPOSE 500/udp 4500/udp 1701/tcp 1194/udp 5555/tcp  
  
CMD ["/usr/local/sbin/run"]  

