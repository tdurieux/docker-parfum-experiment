FROM python:3.9 as builder
ENV CRYPTOGRAPHY_DONT_BUILD_RUST=1
RUN mkdir -p /fastapi-admin
WORKDIR /fastapi-admin
COPY pyproject.toml poetry.lock /fastapi-admin/
ENV POETRY_VIRTUALENVS_CREATE false
RUN pip install --no-cache-dir --upgrade pip && pip3 install --no-cache-dir poetry && poetry install --no-root
COPY . /fastapi-admin
RUN poetry install && make compile

FROM python:3.9-slim
WORKDIR /fastapi-admin
COPY --from=builder /usr/local/lib/python3.9/site-packages /usr/local/lib/python3.9/site-packages
COPY --from=builder /usr/local/bin/ /usr/local/bin/
COPY --from=builder /fastapi-admin /fastapi-admin
