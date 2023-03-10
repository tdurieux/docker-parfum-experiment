FROM python:3.8-slim-buster as base_stage

ARG HTTP_PROXY
ARG HTTPS_PROXY

ENV HTTP_PROXY=${HTTP_PROXY}
ENV HTTPS_PROXY=${HTTPS_PROXY}

# > > > > > > > > > > > > > > > > > > > > > STAGE 1: 
FROM base_stage as build_stage

# Copy in python SDK source
COPY /src/sdk/python ./src/sdk/python
# Copy requirements file
COPY /docker/integration-tests/python-test-suite/requirements.txt .

# Create build directory
RUN mkdir /build
WORKDIR /build

# Install python SDK dependencies
RUN python -m pip install -r ../requirements.txt --user

# Install the latest iotea python SDK from source - see setup.py for details
RUN python -m pip install /src/sdk/python/src/ --user


# > > > > > > > > > > > > > > > > > > > > > STAGE 2: 
FROM build_stage as runtime_stage

ARG INTEGRATION_TESTS
ARG CONFIG_PATH

# Copy the installed requirements and iotea python SDK from build stage
COPY --from=build_stage /root/.local/ /root/.local/
ENV PATH=/root/.local:$PATH

RUN mkdir /app
WORKDIR /app

ARG INTEGRATION_TESTS=/test/integration-tests

RUN mkdir -p test/python
COPY ${INTEGRATION_TESTS}/sdk-test-suites/python/function_provider.py test/python

RUN mkdir -p config/tests/python
COPY ${INTEGRATION_TESTS}/config/tests/python config/tests/python


WORKDIR /app/test/python
ENTRYPOINT ["python", "function_provider.py"]