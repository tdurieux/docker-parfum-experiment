FROM debian:jessie  
  
RUN apt-get update \  
&& apt-get install -y libreoffice \  
&& rm -rf /var/lib/apt/lists/*  
  
ENTRYPOINT ["libreoffice", "--headless"]

