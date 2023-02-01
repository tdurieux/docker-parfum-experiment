ARG VARIANT

FROM tensorflow/tensorflow:2.9.1${VARIANT}

RUN apt-get update && apt-get install --no-install-recommends -y \
  locales \
  && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir flake8 isort black pytest