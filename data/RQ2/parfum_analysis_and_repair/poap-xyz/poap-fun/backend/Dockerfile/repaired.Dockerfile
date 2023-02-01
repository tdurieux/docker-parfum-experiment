FROM python:3.8.3-buster
RUN apt-get update && apt-get install --no-install-recommends -y gettext && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir --upgrade pip

RUN mkdir -p /config
ADD requirements.txt /config/
ADD requirements-docker.txt /config/
RUN pip install --no-cache-dir -r /config/requirements.txt
RUN pip install --no-cache-dir -r /config/requirements-docker.txt
