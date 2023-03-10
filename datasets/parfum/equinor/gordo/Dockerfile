# Gordo base image
FROM python:3.9.12-buster as builder

# Copy source code
COPY . /code
# Copy .git to deduce version number
COPY .git /code/

WORKDIR /code
RUN rm -rf /code/dist \
    && python setup.py sdist \
    && mv /code/dist/$(ls /code/dist | head -1) /code/dist/gordo-packed.tar.gz

# Extract a few big dependencies which docker will cache even when other dependencies change
RUN cat /code/requirements/full_requirements.txt | grep tensorflow== > /code/prereq.txt \
    && cat /code/requirements/full_requirements.txt | grep pyarrow== >> /code/prereq.txt \
    && cat /code/requirements/full_requirements.txt | grep scipy== >> /code/prereq.txt \
    && cat /code/requirements/full_requirements.txt | grep catboost== >> /code/prereq.txt

FROM python:3.9.12-slim-buster

# Nonroot user for running CMD
RUN groupadd -g 999 gordo && \
    useradd -r -u 999 -g gordo gordo

ENV HOME "/home/gordo"
ENV PATH "${HOME}/.local/bin:${PATH}"

RUN apt-get update && apt-get install -y \
    curl \
    jq

# Install requirements separately for improved docker caching
COPY --from=builder /code/prereq.txt .
RUN --mount=type=secret,id=pip_index_url \
    pip install --extra-index-url "$(cat /run/secrets/pip_index_url)" --no-deps -r prereq.txt --no-cache-dir

COPY requirements/full_requirements.txt .
RUN --mount=type=secret,id=pip_index_url \
    pip install --extra-index-url "$(cat /run/secrets/pip_index_url)" -r full_requirements.txt --no-cache-dir

# Install gordo, packaged from earlier 'python setup.py sdist'
COPY --from=builder /code/dist/gordo-packed.tar.gz .
RUN pip install gordo-packed.tar.gz[full]

# Install GordoDeploy dependencies
ARG HTTPS_PROXY
ARG KUBECTL_VERSION="v1.16.9"
ARG ARGO_VERSION="v2.12.11"

#donwload & install kubectl
RUN curl -sSL -o /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/$KUBECTL_VERSION/bin/linux/amd64/kubectl &&\
  chmod +x /usr/local/bin/kubectl

#download & install argo
RUN curl -sLO https://github.com/argoproj/argo-workflows/releases/download/$ARGO_VERSION/argo-linux-amd64.gz &&\
    gzip -d < argo-linux-amd64.gz > /usr/local/bin/argo &&\
    chmod +x /usr/local/bin/argo

COPY ./functions.sh ${HOME}/functions.sh
COPY ./run_workflow_and_argo.sh ${HOME}/run_workflow_and_argo.sh

# Baking in example configs for running tests, as docker.client.containers.run
# bind doesn't seem to work correctly for non-root users
# volumes={repo_dir: {"bind": "/home/gordo", "mode": "ro"}},
COPY ./examples ${HOME}/examples
COPY ./resources ${HOME}/resources

# Install ModelBuilder dependencies
ADD build.sh ${HOME}/build.sh

# build.sh (build the model) as executable default command
RUN cp ${HOME}/build.sh /usr/bin/build \
    && chmod a+x /usr/bin/build


# Make gordo own all in its home
RUN chown -R gordo:gordo ${HOME}

# Run things from gordo's home to have write access when needed (e.g. Catboost tmp files)
WORKDIR ${HOME}
# Switch user
USER 999 
