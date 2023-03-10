FROM readsb_autogain_testing_base:latest

COPY autogain_test_data/ /autogain_test_data/

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN pushd "/autogain_test_data" && \
    tar xJvf ./stats.pb.test_data.tar.xz && rm ./stats.pb.test_data.tar.xz

ENTRYPOINT [ "bash", "/scripts/autogain_test.sh" ]
