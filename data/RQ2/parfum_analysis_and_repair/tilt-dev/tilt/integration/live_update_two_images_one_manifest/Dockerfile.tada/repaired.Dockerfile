FROM busybox
WORKDIR /app
ADD start.sh .
ADD index.html .
ENTRYPOINT ./start.sh