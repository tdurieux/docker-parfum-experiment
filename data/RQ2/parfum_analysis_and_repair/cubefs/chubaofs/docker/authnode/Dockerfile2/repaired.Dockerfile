FROM ubuntu:18.04
RUN mkdir -p /export/Logs/authnode && mkdir -p /export/Data/authnode/raft && mkdir -p /export/Data/authnode/rocksdbstore
CMD /app/cfs-server -c /app/authnode2.json -f 