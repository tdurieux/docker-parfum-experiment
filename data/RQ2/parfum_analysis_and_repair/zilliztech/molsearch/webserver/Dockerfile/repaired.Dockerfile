From conda/miniconda3-centos7

WORKDIR /app
COPY . /app

RUN yum -y update
RUN yum install -y libXext libSM libXrender && rm -rf /var/cache/yum

RUN conda update -n base -c defaults conda
RUN conda install -c rdkit rdkit -y
RUN conda install -c rdkit rdkit-postgresql -y
RUN pip install --no-cache-dir -r /app/requirements.txt

RUN mkdir -p /tmp/result-mols

RUN cd /app
CMD python src/app.py