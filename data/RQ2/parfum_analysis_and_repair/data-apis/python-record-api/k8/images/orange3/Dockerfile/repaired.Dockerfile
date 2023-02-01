ARG FROM
FROM ${FROM}

WORKDIR /usr/src/app


RUN git clone \
    --branch 3.27.1 \
    --depth 1 \
    https://github.com/biolab/orange3.git \
    .

RUN apt update && apt install --no-install-recommends -y libqt5opengl5-desktop-dev && rm -rf /var/lib/apt/lists/*;

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install --no-cache-dir -e . \
    pytest-custom_exit_code \
    pytest

RUN python -c "import Orange"

ENV PYTHON_RECORD_API_FROM_MODULES=Orange
CMD ["pytest", "--verbose", "Orange/tests/", "--suppress-tests-failed-exit-code"]
