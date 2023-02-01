FROM ubuntu:14.04
RUN apt-get update && apt-get install --no-install-recommends -y git python-dev python-pip && rm -rf /var/lib/apt/lists/*;

COPY validate_num_items.py /validate_num_items.py

ENTRYPOINT ["python", "/validate_num_items.py"]