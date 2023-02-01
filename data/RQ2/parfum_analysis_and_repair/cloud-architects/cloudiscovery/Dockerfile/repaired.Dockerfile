FROM python:3.8-slim as cloudiscovery

LABEL maintainer_1="https://github.com/leandrodamascena/"
LABEL maintainer_2="https://github.com/meshuga"
LABEL Project="https://github.com/Cloud-Architects/cloudiscovery"

WORKDIR /opt/cloudiscovery

RUN apt-get update -y
RUN apt-get install --no-install-recommends -y awscli graphviz && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y bash && rm -rf /var/lib/apt/lists/*;

COPY . /opt/cloudiscovery

RUN pip install --no-cache-dir -r requirements.txt

RUN bash