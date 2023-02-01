FROM python:2.7.14

RUN pip install --no-cache-dir oci-cli
RUN apt-get update && apt-get install --no-install-recommends -y jq && rm -rf /var/lib/apt/lists/*;
