FROM python:3.6.7-slim
WORKDIR /code
COPY . .
RUN pip install --no-cache-dir --upgrade pip && pip install --no-cache-dir keyrings.alt && pip install --no-cache-dir --editable .
ENTRYPOINT [ "bash" ]
