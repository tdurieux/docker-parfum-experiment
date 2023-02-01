ARG PYTHON_VERSION=3.8
FROM python:${PYTHON_VERSION}-slim

RUN apt-get update && apt-get install --no-install-recommends -y build-essential autoconf && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir -U contrast-agent

WORKDIR /vulnpy
COPY . .

RUN pip install --no-cache-dir -e .[all]

ENV PORT="3010"
ENV FRAMEWORK="flask"
ENV HOST="0.0.0.0"
ENV VULNPY_USE_CONTRAST="true"

CMD make ${FRAMEWORK}
