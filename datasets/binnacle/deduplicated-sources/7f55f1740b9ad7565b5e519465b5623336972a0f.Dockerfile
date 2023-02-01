FROM debian:stretch-slim
WORKDIR /root/
RUN mkdir /conode_data
RUN mkdir -p .local/share .config
RUN ln -s /conode_data .local/share/conode
RUN ln -s /conode_data .config/conode
RUN apt update; apt install -y procps ca-certificates; apt clean
COPY run_nodes.sh .
COPY exe/conode.Linux.x86_64 ./conode

EXPOSE 7770 7771

CMD [ "./run_nodes.sh", "-n 1" ]
