FROM python:3.8-slim

RUN apt-get update && apt-get install --no-install-recommends -y git && apt-get clean && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir click packaging dunamai actions-toolkit
COPY docker-entrypoint.py /usr/local/bin/docker-entrypoint.py

ENTRYPOINT ["python", "/usr/local/bin/docker-entrypoint.py"]
