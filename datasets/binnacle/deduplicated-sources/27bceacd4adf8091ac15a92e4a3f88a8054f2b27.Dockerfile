FROM ubuntu:latest  
  
RUN apt update && apt install -y curl git zip  
  
CMD ["bash"]  

