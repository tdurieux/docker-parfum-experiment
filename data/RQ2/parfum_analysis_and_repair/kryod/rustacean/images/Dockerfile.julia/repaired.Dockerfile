FROM ubuntu:latest

RUN apt-get update -y && apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;

RUN wget https://julialang-s3.julialang.org/bin/linux/x64/1.4/julia-1.4.2-linux-x86_64.tar.gz && \
    tar -xvzf julia-1.4.2-linux-x86_64.tar.gz && \
    cp -r julia-1.4.2 /opt/ && \
    ln -s /opt/julia-1.4.2/bin/julia /usr/local/bin/julia && \
    rm -rf julia-1.4.2 && rm julia-1.4.2-linux-x86_64.tar.gz
