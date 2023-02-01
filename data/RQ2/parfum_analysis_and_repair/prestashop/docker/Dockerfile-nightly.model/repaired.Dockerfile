FROM prestashop/base:$container_version
LABEL maintainer="PrestaShop Core Team <coreteam@prestashop.com>"

ENV PS_VERSION $ps_version

ENV PATH /root/google-cloud-sdk/bin/:$$PATH

RUN apt update && apt -y --no-install-recommends install \
 python3 \
 curl \
 bash && rm -rf /var/lib/apt/lists/*;

RUN curl -f -sSL https://sdk.cloud.google.com | bash
RUN gcloud config set core/disable_usage_reporting true && \
    gcloud config set component_manager/disable_update_check true && \
    gcloud config set metrics/environment github_docker_image && \
    gcloud --version

CMD ["/tmp/docker_nightly_run.sh"]
