FROM busybox
COPY artifact /subdir/artifact
RUN ln -f /subdir/artifact /subdir/artifact-hardlink