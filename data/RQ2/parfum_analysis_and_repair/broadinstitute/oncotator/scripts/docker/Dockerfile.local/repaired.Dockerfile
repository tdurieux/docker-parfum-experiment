FROM python:2.7.9

MAINTAINER oncotator <oncotator@broadinstitute.org>

RUN apt-get update && apt-get install -y --no-install-recommends unzip && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir numpy

RUN pip install --no-cache-dir ngslib

ADD . /oncotator

RUN cd oncotator/ && python setup.py install

ENTRYPOINT ["Oncotator"]

CMD ["-h"]

# EXAMPLE BUILD CMD
# docker build -t oncotator .

# EXAMPLE RUN CMDS
# docker run -it oncotator -h
# docker run -v /path/to/data:/data -v /path/to/oncotator_db_dir:/db_dir -it oncotator --db-dir /db_dir /data/in.maflite /data/out.maf.txt hg19
