FROM python:3-buster
RUN apt update && apt install --no-install-recommends -y docker.io && rm -rf /var/lib/apt/lists/*;

WORKDIR /projects/sce-domain-discovery/webui

COPY webui/requirements.txt /projects/sce-domain-discovery/webui/

RUN pip install --no-cache-dir -r requirements.txt && mkdir /models && mkdir /images

COPY . /projects/sce-domain-discovery/


CMD ["python", "waitress_server.py"]
