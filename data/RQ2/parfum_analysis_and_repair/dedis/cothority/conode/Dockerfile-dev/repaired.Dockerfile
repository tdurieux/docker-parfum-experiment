ARG FROM

FROM ${FROM}

COPY run_nodes.sh .
COPY exe/conode.Linux.x86_64 ./conode

CMD ["./run_nodes.sh", "-n", "1"]