FROM scratch
WORKDIR /root/
COPY manager /root
ENTRYPOINT ["./manager"]