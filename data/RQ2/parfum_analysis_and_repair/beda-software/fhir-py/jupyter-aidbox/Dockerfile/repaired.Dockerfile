FROM jupyter/datascience-notebook:latest

RUN pip install --no-cache-dir fhirpy --upgrade
ADD examples /examples/

