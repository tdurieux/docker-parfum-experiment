FROM scratch
# Surprise! The --chown flag is ignored when we're extracting archives.
ADD --chown=2:2 testfile.tar.gz /