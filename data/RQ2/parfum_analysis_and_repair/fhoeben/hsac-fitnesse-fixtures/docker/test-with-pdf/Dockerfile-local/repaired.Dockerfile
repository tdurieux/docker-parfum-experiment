ARG  TEST_IMAGE=hsac/fitnesse-fixtures-test-jre8:latest

FROM ${TEST_IMAGE}
COPY wiki/fixtures wiki/fixtures