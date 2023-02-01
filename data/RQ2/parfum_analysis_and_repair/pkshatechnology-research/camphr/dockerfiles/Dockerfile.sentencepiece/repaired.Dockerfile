ARG PYTHON_VERSION
FROM python:${PYTHON_VERSION}-buster
ENV HOME=/root
ARG WORKDIR

# install poetry
RUN pip install --no-cache-dir -U poetry && \
    poetry config virtualenvs.create false

# install python dependencies
RUN mkdir ${HOME}/camphr && \
    touch ${HOME}/camphr/__init__.py && \
    touch ${HOME}/README.md
WORKDIR ${HOME}/${WORKDIR}
COPY ${WORKDIR}/pyproject.toml .
COPY pyproject.toml ${HOME}/
ARG INSTALL_CMD
run ${INSTALL_CMD}

# install source
COPY . ${HOME}
RUN poetry install
