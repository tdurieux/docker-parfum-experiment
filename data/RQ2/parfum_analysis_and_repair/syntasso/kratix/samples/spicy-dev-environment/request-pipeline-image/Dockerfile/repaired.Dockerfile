FROM bitnami/kubectl:1.20.10

USER root

RUN curl -f -sL https://raw.githubusercontent.com/crossplane/crossplane/master/install.sh | sh
RUN mv kubectl-crossplane /opt/bitnami/kubectl/bin

RUN apt-get update
RUN apt-get install -y --no-install-recommends bash && rm -rf /var/lib/apt/lists/*;
RUN apt-get -yq --no-install-recommends install apt-transport-https ca-certificates gnupg && rm -rf /var/lib/apt/lists/*;
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
RUN curl -f https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
RUN apt-get update && apt-get install -y --no-install-recommends google-cloud-cli && rm -rf /var/lib/apt/lists/*;

ADD worker-cluster-resource.yaml worker-cluster-resource.yaml
ADD kratix-worker-cluster.yaml kratix-worker-cluster.yaml
ADD execute-pipeline.sh execute-pipeline.sh
ADD gitops-tk-resources.yaml gitops-tk-resources.yaml

CMD [ "sh", "-c", "./execute-pipeline.sh"]
ENTRYPOINT []
