# rebuild in #33610
# docker build -t clickhouse/unit-test .
ARG FROM_TAG=latest
FROM clickhouse/stateless-test:$FROM_TAG

RUN apt-get install -y --no-install-recommends gdb && rm -rf /var/lib/apt/lists/*;

COPY run.sh /
COPY process_unit_tests_result.py /
CMD ["/bin/bash", "/run.sh"]
