FROM jupyter/datascience-notebook:python-3.9.7
ARG  pypi="https://pypi.org/simple"
ENV  pypi=$pypi
USER root
COPY . /app
RUN pip install --no-cache-dir /app/packages/*whl -i $pypi -U --upgrade-strategy only-if-needed --progress-bar off omegaml[all]
RUN /app/scripts/setupnb.sh
#ensure PYTHONUSERBASE is created
USER jovyan
RUN pip install --no-cache-dir --user -U six


