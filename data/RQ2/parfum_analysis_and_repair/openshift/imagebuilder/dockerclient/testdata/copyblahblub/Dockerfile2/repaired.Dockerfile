FROM busybox
COPY /firstdir/seconddir /var
RUN ls -la /var
RUN ls -la /var/dir-a