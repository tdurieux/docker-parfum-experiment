FROM ossrs/srs:dev AS build

COPY . /usr/local/srs-bench
WORKDIR /usr/local/srs-bench
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make

############################################################
# dist
############################################################
FROM centos:7 AS dist

COPY --from=build /usr/local/bin /usr/local/bin
COPY --from=build /usr/local/srs-bench /usr/local/srs-bench

WORKDIR /usr/local/srs-bench
CMD ["bash", "-c", "ls -lh objs"]

