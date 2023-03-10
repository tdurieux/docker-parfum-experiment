FROM intelotc/dffml

RUN pip install --no-cache-dir -U coverage codecov sphinx sphinxcontrib-asyncio

WORKDIR /usr/src/dffml-service-http
COPY setup.py .
COPY README.md .
COPY dffml_service_http/version.py ./dffml_service_http/

RUN pip install --no-cache-dir -e .[dev]

COPY . .

CMD ["service", "http", "server"]
