FROM python:3.7
RUN pip install --no-cache-dir jsonpickle python-arango jupyter sklearn2 PyYAML==5.1.1 arangopipe==0.0.6.1
WORKDIR /
COPY tests/prod_docker/test_installation.py tests/



