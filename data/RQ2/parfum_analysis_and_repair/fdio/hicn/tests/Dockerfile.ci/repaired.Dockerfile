ARG BASE_IMAGE

FROM ${BASE_IMAGE}

RUN sudo sed -i 's,secure_path="\(.*\)",secure_path="/hicn-root/bin:\1",' /etc/sudoers