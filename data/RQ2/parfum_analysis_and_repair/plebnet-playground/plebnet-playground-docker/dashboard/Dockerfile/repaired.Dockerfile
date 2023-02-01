FROM continuumio/miniconda3:latest
LABEL maintainer "Asher Pembroke <apembroke@gmail.com>"

RUN conda install -y python=3.7
RUN conda install jupyter
RUN conda install jupytext -c conda-forge
RUN conda install -c conda-forge dash pandas scipy numpy networkx
RUN pip install --no-cache-dir jupyter-dash
RUN pip install --no-cache-dir dash-bootstrap-components
RUN pip install --no-cache-dir git+https://github.com/predsci/psidash.git


RUN pip install --no-cache-dir grpcio grpcio-tools googleapis-common-protos

WORKDIR /grpc

RUN git clone --depth 1 https://github.com/googleapis/googleapis.git
RUN wget https://raw.githubusercontent.com/lightningnetwork/lnd/master/lnrpc/lightning.proto
RUN python -m grpc_tools.protoc --proto_path=googleapis:. --python_out=. --grpc_python_out=. lightning.proto

COPY . /dashboard

WORKDIR /dashboard

# set up jupyter
RUN jupyter notebook --generate-config
ENV JUPYTER_PASSWORD plebnet
ENV JUPYTER_PORT 8888
ENV JUPYTER_NOTEBOOKS /dashboard

RUN chmod +x /dashboard/jupyter_run.sh
CMD ["/dashboard/jupyter_run.sh"]