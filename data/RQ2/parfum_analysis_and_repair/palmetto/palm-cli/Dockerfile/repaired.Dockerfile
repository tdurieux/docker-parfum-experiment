FROM python:3.8
COPY . /app
RUN export PYTHONPATH=/app
WORKDIR /app
RUN pip install --no-cache-dir -r dev-requirements.txt
