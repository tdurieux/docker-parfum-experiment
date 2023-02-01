FROM python:3.9-slim
COPY . /oopt-gnpy
WORKDIR /oopt-gnpy
RUN apt update; apt install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir .
WORKDIR /shared/example-data
ENTRYPOINT ["/oopt-gnpy/.docker-entry.sh"]
CMD ["/bin/bash"]
