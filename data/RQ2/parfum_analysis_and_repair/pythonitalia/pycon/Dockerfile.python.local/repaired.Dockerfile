ARG FUNCTION_DIR="/home/app/"

FROM python:3.9

ARG FUNCTION_DIR

RUN mkdir -p ${FUNCTION_DIR}
WORKDIR ${FUNCTION_DIR}

RUN pip3 install --no-cache-dir poetry

COPY poetry.lock ${FUNCTION_DIR}
COPY pyproject.toml ${FUNCTION_DIR}

RUN mkdir -p ${FUNCTION_DIR}/assets

RUN poetry config virtualenvs.create false
RUN poetry install

COPY . ${FUNCTION_DIR}
