ARG CODE_VERSION
FROM clipper/py-rpc:${CODE_VERSION}

LABEL maintainer="Dan Crankshaw <dscrankshaw@gmail.com>"

COPY containers/python/noop_container.py /container/
COPY bench/setup_noop_bench_docker.sh /bench/
COPY bench/set_bench_env_vars.sh /bench/
COPY bench/export_aws_ip.sh /bench/

ENV MODEL_NAME bench_noop
ENV MODEL_VERSION 1

CMD /bench/setup_noop_bench_docker.sh

# vim: set filetype=dockerfile: