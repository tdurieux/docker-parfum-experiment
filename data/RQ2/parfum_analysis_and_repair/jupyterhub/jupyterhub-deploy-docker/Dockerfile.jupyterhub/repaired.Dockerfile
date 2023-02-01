# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.
ARG JUPYTERHUB_VERSION
FROM jupyterhub/jupyterhub-onbuild:$JUPYTERHUB_VERSION

# Install dockerspawner, oauth, postgres
RUN /opt/conda/bin/conda install -yq psycopg2=2.7 && \
    /opt/conda/bin/conda clean -tipsy && \
    /opt/conda/bin/pip install --no-cache-dir \
        oauthenticator==0.8.* \
        dockerspawner==0.9.*

# Copy TLS certificate and key