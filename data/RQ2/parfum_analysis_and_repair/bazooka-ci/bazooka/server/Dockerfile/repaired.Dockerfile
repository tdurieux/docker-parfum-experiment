FROM busybox:ubuntu-14.04

COPY main /bin/main

ENTRYPOINT ["/bin/main"]

EXPOSE 3000 3001