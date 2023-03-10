FROM python:3.6.5

ENV PYTHONUNBUFFERED 1

RUN mkdir /code
WORKDIR /code

RUN apt-get update && \
  apt-get install --no-install-recommends -y unzip && \
  rm -rf /var/lib/apt/lists/*

ADD requirements/* /code/

RUN pip install --no-cache-dir -r code_upload_worker.txt

ADD . /code

RUN chmod +x scripts/workers/code_upload_worker_utils/install_dependencies.sh

CMD ["scripts/workers/code_upload_worker_utils/install_dependencies.sh"]
