FROM registry.fedoraproject.org/fedora-minimal:31
RUN microdnf install fio vi && microdnf clean all
RUN mkdir scripts
WORKDIR scripts
ADD ./runs ./

CMD tail -f /dev/null
