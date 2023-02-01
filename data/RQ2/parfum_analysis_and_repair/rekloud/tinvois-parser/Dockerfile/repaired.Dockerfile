#FROM python:3.8-slim
FROM tiangolo/meinheld-gunicorn-flask:python3.8

WORKDIR /app

RUN useradd -ms /bin/bash taxapp && \
  apt-get update && apt-get install --no-install-recommends curl unixodbc-dev gnupg2 --yes && \
  apt-get install --no-install-recommends libgl1-mesa-glx --yes && rm -rf /var/lib/apt/lists/*;
COPY --chown=taxapp app .
RUN pip install --no-cache-dir -r ./requirements.txt
RUN pip uninstall -y greenlet
RUN pip install --no-cache-dir greenlet==0.4.17

USER taxapp
