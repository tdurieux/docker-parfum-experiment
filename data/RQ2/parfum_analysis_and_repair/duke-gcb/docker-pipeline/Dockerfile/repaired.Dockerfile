FROM phusion/baseimage
MAINTAINER Dan Leehr <dan.leehr@duke.edu>

RUN apt-get update && apt-get install --no-install-recommends -y \
  python \
  python-dev \
  libffi-dev \
  libssl-dev \
  python-pip && rm -rf /var/lib/apt/lists/*;

COPY requirements.txt /
RUN pip install --no-cache-dir -r requirements.txt
COPY docker-pipeline /docker-pipeline
WORKDIR /docker-pipeline
ENTRYPOINT ["python", "pipeline.py"]
CMD ["-h"]
