FROM dreg.cloud.sdu.dk/ucloud/base:2021.3.0
USER 0
RUN curl https://storage.googleapis.com/kubernetes-release/release/v1.18.0/bin/linux/amd64/kubectl -o /tmp/kubectl
RUN mv /tmp/kubectl /usr/bin/kubectl
RUN chmod +x /usr/bin/kubectl
USER 11042
COPY build/service /opt/service
CMD ["/opt/service/bin/service"]
