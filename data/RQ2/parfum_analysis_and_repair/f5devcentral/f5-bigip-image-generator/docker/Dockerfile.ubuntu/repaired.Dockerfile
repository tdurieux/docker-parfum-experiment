ARG BASE_REPO
FROM ${BASE_REPO}
ARG PARAMETERS
ARG USERNAME
WORKDIR /workdir
COPY . /workdir/
RUN apt-get update && \
    apt-get -y --no-install-recommends install sudo && rm -rf /var/lib/apt/lists/*;
RUN bash /workdir/setup-build-env $PARAMETERS
ENV VENV_DIR /workdir/.venv
ENV PATH ${VENV_DIR}/bin:$PATH
ENV PYTHONPATH /workdir/.venv/bin
ENV USER $USERNAME
