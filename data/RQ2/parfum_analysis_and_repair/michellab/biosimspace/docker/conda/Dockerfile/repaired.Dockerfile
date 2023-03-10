# This image is used to build and deploy the BioSimSpace Conda package.

FROM biosimspace/biosimspace-devel:latest

WORKDIR $HOME

USER $FN_USER

# Import arguments and set environment variables.
ARG anaconda_token
ENV ANACONDA_TOKEN=$anaconda_token

# Install conda-build and anaconda-client
RUN $HOME/sire.app/bin/conda install -y conda-build anaconda-client

# Update the Conda package recipe.
ADD update_recipe.sh .
RUN $HOME/update_recipe.sh

# Build and deploy the Conda package.