FROM ubuntu:latest
RUN apt-get update && apt-get install --no-install-recommends build-essential curl -y && apt-get clean && rm -rf /var/lib/apt/lists/*;
RUN curl -f -O -J -L https://github.com/embree/embree/releases/download/v3.8.0/embree-3.8.0.x86_64.linux.tar.gz && tar xvf embree-3.8.0.x86_64.linux.tar.gz && mv embree-3.8.0.x86_64.linux/lib/* /usr/lib && mv embree-3.8.0.x86_64.linux/include/* /usr/include && rm -r embree-3.8.0.x86_64.linux embree-3.8.0.x86_64.linux.tar.gz
