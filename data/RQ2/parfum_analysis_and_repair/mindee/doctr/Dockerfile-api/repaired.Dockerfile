FROM tiangolo/uvicorn-gunicorn-fastapi:python3.8-slim

WORKDIR /app

# set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
ENV PYTHONPATH "${PYTHONPATH}:/app"

# copy requirements file
COPY api/requirements.txt /app/api-requirements.txt
COPY ./requirements.txt /tmp/requirements.txt

RUN apt-get update \
    && apt-get install --no-install-recommends ffmpeg libsm6 libxext6 -y \
    && pip install --no-cache-dir --upgrade pip setuptools wheel \
    && pip install --no-cache-dir -r /app/api-requirements.txt \
    && pip install --no-cache-dir -r /tmp/requirements.txt \
    && pip cache purge \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /root/.cache/pip

# install doctr
COPY ./README.md /tmp/README.md
COPY ./setup.py /tmp/setup.py
COPY ./doctr /tmp/doctr

RUN pip install --no-cache-dir -e /tmp/.[tf] \
    && pip cache purge \
    && rm -rf /root/.cache/pip

# copy project
COPY api /app
