FROM jupyter/minimal-notebook

USER root
RUN apt-get update && apt-get install --no-install-recommends -y gnupg bash-completion build-essential curl openssl ssh && \
    echo "deb http://packages.cloud.google.com/apt cloud-sdk-stretch main" >> /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl -f https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    apt-get update -y && apt-get install --no-install-recommends -y google-cloud-sdk kubectl postgresql nano dnsutils && \
    wget -q https://dl.minio.io/client/mc/release/linux-amd64/mc -O /usr/local/bin/mc && \
    chmod +x /usr/local/bin/mc && \
    conda update -n base conda && rm -rf /var/lib/apt/lists/*;
COPY environment.yaml /opt/ckan-cloud-operator/environment.yaml
RUN conda env create -f /opt/ckan-cloud-operator/environment.yaml &&\
    conda clean -ya
COPY ckan_cloud_operator /opt/ckan-cloud-operator/ckan_cloud_operator
COPY setup.py /opt/ckan-cloud-operator/
RUN bash -c ". /opt/conda/bin/activate ckan-cloud-operator &&\
            cd /opt/ckan-cloud-operator && python3 -m pip install -e ."
RUN chown -R jovyan /opt/ckan-cloud-operator

USER jovyan
ENV CKAN_CLOUD_OPERATOR_USE_PROXY=n
