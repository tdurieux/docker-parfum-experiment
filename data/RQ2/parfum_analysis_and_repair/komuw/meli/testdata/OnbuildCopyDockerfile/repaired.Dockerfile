FROM komuw/busyboxonbuild

# add a check to guard against issues/74
RUN ls -lsa && cat Dockerfile