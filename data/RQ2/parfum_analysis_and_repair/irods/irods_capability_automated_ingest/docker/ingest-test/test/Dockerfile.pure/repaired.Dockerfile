FROM python:3.5

ARG PIP_PACKAGE="irods-capability-automated-ingest"

RUN pip install --no-cache-dir ${PIP_PACKAGE}

COPY irods_environment.json /

ENV TEST_CASE=${TEST_CASE}

ENTRYPOINT python -m unittest ${TEST_CASE:-irods_capability_automated_ingest.test.test_irods_sync}

#FROM ingest:latest
#ENV TEST_CASE=${TEST_CASE}
#ENTRYPOINT python -m unittest ${TEST_CASE:-irods_capability_automated_ingest.test.test_irods_sync}
