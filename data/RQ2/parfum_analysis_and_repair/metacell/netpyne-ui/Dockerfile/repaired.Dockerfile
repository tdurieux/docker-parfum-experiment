FROM frodriguez4600/jupyter-neuron:v7.8.0
ARG INSTALLATION_FOLDER=/home/jovyan/work/NetPyNE-UI
ARG NETPYNE_VERSION=development
ARG WORKSPACE_VERSION=nov2020
ARG GEPPETTO_VERSION=development
ARG BUILD_ARGS=""

USER $NB_USER

ENV INSTALLATION_FOLDER=$INSTALLATION_FOLDER
ENV NETPYNE_VERSION=$NETPYNE_VERSION
ENV WORKSPACE_VERSION=$WORKSPACE_VERSION
ENV GEPPETTO_VERSION=$GEPPETTO_VERSION
ENV BUILD_ARGS=$BUILD_ARGS

# Install openmpi for parallel simulations
# Important: Have to switch to root to install a package and ensure to switch back to NB user afterwards
USER root
RUN apt-get update && apt-get install --no-install-recommends -y libopenmpi-dev && rm -rf /var/lib/apt/lists/*;
USER $NB_USER

WORKDIR /home/jovyan/work
COPY --chown=1000:1000 requirements.txt ${INSTALLATION_FOLDER}/requirements.txt

WORKDIR ${INSTALLATION_FOLDER}
RUN pip install --no-cache-dir -r requirements.txt

COPY --chown=1000:1000 . .
WORKDIR ${INSTALLATION_FOLDER}/utilities

RUN npm install --global yarn && npm cache clean --force;
RUN npm install --global yalc && npm cache clean --force;
RUN python install.py ${BUILD_ARGS} --geppetto ${GEPPETTO_VERSION}

WORKDIR ${INSTALLATION_FOLDER}

RUN pip install --no-cache-dir -r requirements-test.txt
RUN pytest tests/backend
CMD /bin/bash -c "jupyter notebook --NotebookApp.default_url=/geppetto --NotebookApp.token='' --library=netpyne_ui --NotebookApp.disable_check_xsrf=True"
