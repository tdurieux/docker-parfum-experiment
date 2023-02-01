####################################################################################################
#
# DAGSTER BUILDKITE TEST IMAGE BUILDER BASE
#
# We use this Dockerfile to build the base image for the test Dagster project
# image that is built in our CI pipeline.
#
####################################################################################################
ARG BASE_IMAGE
ARG PYTHON_VERSION
FROM "${BASE_IMAGE}" AS snapshot_builder

RUN apt-get update -yqq \
    && apt-get install --no-install-recommends -yqq \
        build-essential \
        cron \
        g++ \
        gcc \
        git \
        make && rm -rf /var/lib/apt/lists/*;

RUN git clone https://github.com/dagster-io/dagster.git \
    && cd dagster \
    && pip install --no-cache-dir \
        -e python_modules/dagster \
        -e python_modules/dagster \
        -e python_modules/dagit \
        -e python_modules/librari \
        -e python_modules/librari \
        -e python_modules/librari \
        -e python_modules/librari \
        -e python_modules/librari \
        -e python_modules/librari \
        -e python_modules/librari \
    && pip freeze --exclude-editable > /snapshot-reqs.txt


FROM "${BASE_IMAGE}"

COPY --from=snapshot_builder /snapshot-reqs.txt .

# gcc etc needed for building gevent
RUN apt-get update -yqq \
    && apt-get install --no-install-recommends -yqq \
        build-essential \
        cron \
        g++ \
        gcc \
        git \
        make && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir -r /snapshot-reqs.txt \
    && rm /snapshot-reqs.txt
