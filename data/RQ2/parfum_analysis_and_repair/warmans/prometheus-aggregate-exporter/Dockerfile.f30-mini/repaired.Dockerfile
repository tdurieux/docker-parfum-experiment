FROM registry.fedoraproject.org/fedora-minimal:30 

COPY ./bin/prometheus-aggregate-exporter /bin/aggregate-exporter

CMD ["aggregate-exporter"]