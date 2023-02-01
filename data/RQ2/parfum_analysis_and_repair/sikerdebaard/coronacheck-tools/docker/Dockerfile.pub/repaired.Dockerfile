ARG PYTHON
FROM python:${PYTHON}

RUN apt-get update && apt-get install --no-install-recommends ffmpeg libsm6 libxext6 zbar-tools -y && rm -rf /var/lib/apt/lists/*;

ARG VERSION
RUN pip install --no-cache-dir coronacheck-tools==${VERSION}

ENTRYPOINT ["coronacheck-tools"]
