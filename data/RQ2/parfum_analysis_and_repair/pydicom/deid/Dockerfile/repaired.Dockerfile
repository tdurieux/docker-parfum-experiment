FROM continuumio/miniconda3

RUN apt-get update && apt-get install --no-install-recommends -y wget git pkg-config libfreetype6-dev g++ && rm -rf /var/lib/apt/lists/*;
RUN conda install matplotlib
WORKDIR /code
ADD . /code
RUN python /code/setup.py install

RUN chmod 0755 /opt/conda/bin/deid
ENTRYPOINT ["/opt/conda/bin/deid"]
