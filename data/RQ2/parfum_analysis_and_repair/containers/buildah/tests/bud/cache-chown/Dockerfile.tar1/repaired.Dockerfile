FROM scratch
# Surprise! The --chown flag is ignored when we're extracting archives.
ADD --chown=1:1 testfile.tar.gz /