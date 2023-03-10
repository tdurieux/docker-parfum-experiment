# DockerFile for a firedrake + jupyter container

FROM firedrakeproject/firedrake

# This DockerFile is looked after by
MAINTAINER David Ham <david.ham@imperial.ac.uk>

USER firedrake

WORKDIR /home/firedrake
# Install an iPython kernel for firedrake
RUN bash -c ". /home/firedrake/firedrake/bin/activate && pip install jupyterhub ipykernel notebook ipywidgets mpltools nbformat nbconvert"
RUN bash -c ". /home/firedrake/firedrake/bin/activate && jupyter nbextension enable --py widgetsnbextension --sys-prefix"

# Remove the install log.
RUN bash -c "rm firedrake-*"
# Put the notebooks in the working directory for the notebook server.
RUN bash -c "cp -r firedrake/src/firedrake/docs/notebooks/* ."
# Strip the output from the notebooks.
RUN bash -c '. /home/firedrake/firedrake/bin/activate && for file in *.ipynb; do jupyter nbconvert --ClearOutputPreprocessor.enabled=True --inplace $file; done'

# Now do the same for thetis.
RUN bash -c "mkdir thetis"
RUN bash -c "cp -r firedrake/src/thetis/demos/* thetis/."
RUN bash -c "rm thetis/*.py"
RUN bash -c '. /home/firedrake/firedrake/bin/activate && for file in thetis/*.ipynb; do jupyter nbconvert --ClearOutputPreprocessor.enabled=True --inplace $file; done'

# Environment required for Azure deployments.