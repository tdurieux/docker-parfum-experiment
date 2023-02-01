FROM python:3.10

RUN apt update && apt install --no-install-recommends -y netcat && rm -rf /var/lib/apt/lists/*;

COPY irods_environment.json /

ENV TEST_CASE=${TEST_CASE}

COPY run_tests.sh /
RUN chmod u+x /run_tests.sh
ENTRYPOINT ["./run_tests.sh"]
