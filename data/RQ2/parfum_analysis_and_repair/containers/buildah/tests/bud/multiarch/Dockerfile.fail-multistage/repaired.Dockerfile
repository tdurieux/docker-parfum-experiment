FROM registry.access.redhat.com/ubi8-micro
RUN touch -r /etc/os-release /timestamped
RUN sleep 0
FROM registry.access.redhat.com/ubi8-micro
COPY --from=0 /timestamped /timestamped
RUN sleep 0
FROM registry.access.redhat.com/ubi8-micro
COPY --from=1 /timestamped /timestamped
RUN sleep 0
FROM registry.access.redhat.com/ubi8-micro
COPY --from=2 /timestamped /timestamped
RUN false
FROM registry.access.redhat.com/ubi8-micro
COPY --from=3 /timestamped /timestamped
RUN sleep 0
FROM registry.access.redhat.com/ubi8-micro
COPY --from=4 /timestamped /timestamped
RUN sleep 0