FROM busybox
COPY /firstdir/seconddir /var
RUN ls -la /var
RUN ls -la /var/dir-a
FROM busybox
COPY --from=0 /var/dir-a /var
RUN ls -la /var
RUN ls -la /var/file-a