FROM python:latest
RUN apt-get update && apt-get install --no-install-recommends -y libolm-dev rsync && rm -rf /var/lib/apt/lists/*;
COPY ./requirements.txt /
RUN pip install --no-cache-dir -r /requirements.txt && rm -f /requirements.txt
