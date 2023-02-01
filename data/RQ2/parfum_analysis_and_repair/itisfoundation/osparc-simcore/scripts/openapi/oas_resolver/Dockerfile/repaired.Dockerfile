# Usage:
# docker build . -t oas_resolver
# docker run -v /path/to/api:/input -v /path/to/compiled/file:/output oas_resolver /input/path/to/openapi.yaml /output/output_file.yaml
FROM python:3.6-alpine

LABEL maintainer=sanderegg

VOLUME [ "/input" ]
VOLUME [ "/output" ]

WORKDIR /src

# update pip
RUN pip install --no-cache-dir --upgrade \
      pip~=22.0  \
      wheel \
      setuptools

RUN pip install --no-cache-dir prance && \
      pip install --no-cache-dir click && \
    pip install --no-cache-dir openapi_spec_validator

ENTRYPOINT [ "prance", "compile" , "--backend=openapi-spec-validator"]
