FROM ubuntu

RUN apt-get update && \
    apt-get -y --no-install-recommends install curl python3 python3-pip git vim tree zip make && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir -U pip
RUN pip3 install --no-cache-dir awscli boto3 requests pytest

RUN apt-get clean && apt-get install --no-install-recommends -y apt-transport-https gnupg2 && \
    curl -f -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list && \
    apt-get update && \
    apt-get install --no-install-recommends -y kubectl && rm -rf /var/lib/apt/lists/*;

# Rebuild instructions:
#   docker build -f i_and_a_builder_agent.Dockerfile -t i_and_a_builder_agent .
#   registry="docker-registry.asf.alaska.edu:5000"
#   apptag="i_and_a_builder_agent"
#   appjustbuilt=$(docker images -q "$apptag")
#   docker tag ${appjustbuilt} ${registry}/${apptag}
#   docker push ${registry}/${apptag}

CMD ["tail", "-f", "/dev/null"]
