FROM bitnami/python:3.9.5-prod

WORKDIR /tmp/scripts

COPY requirements.txt ./
RUN apt-get -y update && apt-get -y --no-install-recommends install git && rm -rf /var/lib/apt/lists/*;
RUN python3 -m pip install --no-cache-dir --upgrade pip && \
    python3 -m pip install --no-cache-dir -r requirements.txt
RUN git clone --branch main https://github.com/vmware-samples/sddc-import-export-for-vmware-cloud-on-aws.git
# Example execution:
# docker run --rm -it -v /tmp/json:/tmp/scripts/json -v /tmp/config_ini:/tmp/scripts/config_ini sddc-impexp
