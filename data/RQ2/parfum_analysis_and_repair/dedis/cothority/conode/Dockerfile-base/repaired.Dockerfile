FROM debian:stretch-slim
RUN apt update && apt install --no-install-recommends -y procps ca-certificates && apt clean && rm -rf /var/lib/apt/lists/*;
WORKDIR /root/
RUN mkdir /conode_data
RUN mkdir -p .local/share .config
RUN ln -s /conode_data .local/share/conode
RUN ln -s /conode_data .config/conode

EXPOSE 7770 7771
