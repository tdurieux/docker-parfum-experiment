FROM golang:1.5  
# install clang-format  
RUN apt-get update && apt-get install -y --no-install-recommends \  
clang-format-3.5 && \  
rm -rf /var/lib/apt/lists/*  

