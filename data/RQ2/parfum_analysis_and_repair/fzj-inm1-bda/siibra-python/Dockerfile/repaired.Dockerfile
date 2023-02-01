# Inspired from https://www.docker.com/blog/containerized-python-development-part-1/

FROM jupyter/minimal-notebook:lab-3.2.5 as builder

USER root
RUN apt-get update && apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir -U pip

COPY . /siibra-python
WORKDIR /siibra-python
RUN pip install --no-cache-dir .

FROM jupyter/minimal-notebook:lab-3.2.5

COPY --from=builder /opt/conda /opt/conda

# HBP_AUTH_TOKEN
