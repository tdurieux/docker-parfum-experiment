FROM codenvy/ubuntu_jre  
  
RUN sudo apt-get update && \  
sudo apt-get install g++ gcc make -y && \  
sudo apt-get clean && \  
sudo apt-get -y autoremove && \  
sudo rm -rf /var/lib/apt/lists/*  
  
EXPOSE 8080  
CMD tailf /dev/null  

