FROM quay.io/centos/centos:stream9

COPY deploy/nightly-bundle/deploy.sh /deploy.sh
COPY deploy/nightly-bundle/create_docker_config.sh /create_docker_config.sh
COPY deploy/nightly-bundle/kubevirt-testing-infra.yaml /kubevirt-testing-infra.yaml
COPY deploy/nightly-bundle/kubevirt-tests-pod-spec-override.json.in /kubevirt-tests-pod-spec-override.json.in

RUN yum install -y jq sed skopeo && rm -rf /var/cache/yum
RUN chmod +x /deploy.sh /create_docker_config.sh
