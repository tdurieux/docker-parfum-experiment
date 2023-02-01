FROM python:2.7

WORKDIR /usr/src/databricks-cli

COPY . .

RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r dev-requirements-py2.txt && \
    pip list && \
    ./lint.sh && \
    pip install --no-cache-dir . && \
    pytest tests

ENTRYPOINT [ "databricks" ]
