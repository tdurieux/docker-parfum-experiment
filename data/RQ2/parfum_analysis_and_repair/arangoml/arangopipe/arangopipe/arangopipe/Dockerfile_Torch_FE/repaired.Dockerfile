FROM arangodb:3.6.3

FROM node:8.7.0-alpine AS frontend
RUN mkdir -p /arangopipe_frontend
WORKDIR /arangopipe_frontend
COPY arangopipe_frontend/app/package.json /arangopipe_frontend
COPY arangopipe_frontend/app/package-lock.json /arangopipe_frontend
RUN npm install && npm cache clean --force;
COPY arangopipe_frontend/app/ /arangopipe_frontend

FROM continuumio/miniconda3
MAINTAINER Joerg Schad <info@arangodb.com>
ENV GIT_PYTHON_REFRESH=quiet
RUN apt-get update && apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir mlflow hyperopt sklearn2 jsonpickle python-arango jupyter matplotlib PyYAML==5.1.1 arangopipe==0.0.6.9.3
RUN mkdir -p /workspace
#RUN conda install pytorch
RUN pip install --no-cache-dir torch==1.2.0 torchtext==0.4

WORKDIR /
COPY --from=0 / .
COPY aisis-foxx/ aisis-foxx/
WORKDIR /workspace/experiments
COPY --from=frontend /arangopipe_frontend .
COPY tests/AQL/ examples/AQL/
COPY tests/test_config/ examples/test_config/
COPY tests/covariate_shift/ examples/covariate_shift/
COPY tests/hyperopt/ examples/hyperopt/
COPY tests/mlflow/ examples/mlflow/
COPY tests/test_data_generator/ examples/test_data_generator/
COPY tests/managed_services/connecting_to_arangodb_managed_services.ipynb examples/managed_services/
COPY tests/pytorch/ examples/pytorch/
COPY arangopipe_examples_torch.ipynb .
COPY tests/container_tests/torch_arangopipe_testcases.py examples/container_tests/
COPY tests/covariate_shift/cal_housing.csv examples/container_tests/
ENV PYTHONPATH=`pwd`:$PYTHONPATH:/workspace/experiments/examples/pytorch
RUN jupyter notebook --generate-config --allow-root
RUN echo "c.NotebookApp.password = u'sha1:6a3f528eec40:6e896b6e4828f525a6e20e5411cd1c8075d68619'" >> /root/.jupyter/jupyter_notebook_config.py

EXPOSE 8888 8529 3000

COPY startup_commands.sh /workspace/experiments/startup_commands.sh
RUN ["chmod", "+x", "/workspace/experiments/startup_commands.sh"]
ENTRYPOINT ["/workspace/experiments/startup_commands.sh"]
