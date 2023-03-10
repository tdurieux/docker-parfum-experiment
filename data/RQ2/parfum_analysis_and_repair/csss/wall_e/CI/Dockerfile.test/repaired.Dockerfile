FROM python:3.8.5-alpine

ARG CONTAINER_HOME_DIR

ENV CONTAINER_HOME_DIR=$CONTAINER_HOME_DIR

ARG UNIT_TEST_RESULTS

ENV UNIT_TEST_RESULTS=$UNIT_TEST_RESULTS

ARG TEST_RESULT_FILE_NAME

ENV TEST_RESULT_FILE_NAME=$TEST_RESULT_FILE_NAME



WORKDIR $CONTAINER_HOME_DIR

COPY wall_e/test/test-requirements.txt ./

COPY wall_e/src ./

COPY wall_e/test/pytest.ini ./

COPY wall_e/test/setup.cfg ./

RUN pip install --no-cache-dir -r test-requirements.txt

RUN mkdir -p $UNIT_TEST_RESULTS

CMD ["sh" , "-c", "py.test --junitxml=${UNIT_TEST_RESULTS}/${TEST_RESULT_FILE_NAME}" ]