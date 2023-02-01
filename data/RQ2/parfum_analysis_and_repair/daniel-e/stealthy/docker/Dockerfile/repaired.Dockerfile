FROM ubuntu:18.10

RUN apt-get update
RUN apt-get -y --no-install-recommends install apt-utils aptitude git curl net-tools iputils-ping tcpdump && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install build-essential libpcap-dev libssl-dev && rm -rf /var/lib/apt/lists/*;

# install latest rust via rustup
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
RUN echo "source /root/.cargo/env" >> /root/.bashrc
ENV PATH="/root/.cargo/bin:${PATH}"

# install stealthy from github
WORKDIR /root/
RUN git clone https://github.com/daniel-e/stealthy.git stealthy.git
WORKDIR /root/stealthy.git
RUN cargo build --release
RUN cp target/release/stealthy /root/

WORKDIR /root/
RUN echo "PATH=$PATH:/root/" >> /root/.bashrc
RUN echo "ifconfig eth0 | grep inet | awk '{print \$2}'" >> /root/.bashrc

CMD ["/bin/bash"]
