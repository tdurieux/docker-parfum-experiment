FROM python:3.10-buster

RUN apt-get update && apt-get install --no-install-recommends -y libsnappy-dev && pip install --no-cache-dir python-snappy && rm -rf /var/lib/apt/lists/*;

COPY ./developer_requirements.txt /developer_requirements.txt
RUN pip install --no-cache-dir -r /developer_requirements.txt

COPY . /source
WORKDIR /source
RUN sed -i -e 's/\r//' /source/run-tests.sh

RUN /bin/bash /source/run-tests.sh
