ARG PYTHON
FROM python:${PYTHON}

WORKDIR /app
COPY . /app


RUN apt-get update && apt-get install --no-install-recommends ffmpeg libsm6 libxext6 zbar-tools -y && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir -e .

ENTRYPOINT ["coronacheck-tools"]