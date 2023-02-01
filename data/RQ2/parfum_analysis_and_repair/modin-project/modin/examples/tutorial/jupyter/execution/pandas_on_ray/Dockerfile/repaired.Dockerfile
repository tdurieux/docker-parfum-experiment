FROM continuumio/miniconda3

RUN conda install -c conda-forge psutil setproctitle
RUN pip install --no-cache-dir -r requirements-dev.txt

