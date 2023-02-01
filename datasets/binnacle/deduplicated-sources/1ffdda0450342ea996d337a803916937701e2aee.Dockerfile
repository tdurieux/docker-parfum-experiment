########################################################################
# ASA course Dockerfile
# Web: https://github.com/gboeing/asa
#
# Build an image from the dockerfile:
# >>> docker build -t gboeing/asa .
#
# Push the built image to hub so others can pull/run it:
# >>> docker tag gboeing/asa gboeing/asa:latest
# >>> docker login
# >>> docker push gboeing/asa
#
# Run bash in this container and export final conda environment to a yml file:
# >>> docker run --rm -it -u 0 --name asa -v %cd%:/home/jovyan/work gboeing/asa /bin/bash
# >>> conda env export -n base > /home/jovyan/work/environment.yml
#
# Run jupyter lab in this container:
# >>> docker run --rm -it --name asa -p 8888:8888 -v %cd%:/home/jovyan/work gboeing/asa
#
# Stop/delete all local docker containers/images:
# >>> docker stop $(docker ps -aq)
# >>> docker rm $(docker ps -aq)
# >>> docker rmi $(docker images -q)
########################################################################

FROM jupyter/base-notebook
LABEL maintainer="Geoff Boeing <g.boeing@northeastern.edu>"

# symlink and permissions
USER root
RUN ln -s /opt/conda/bin/jupyter /usr/local/bin
USER $NB_UID

COPY requirements.txt /tmp/

RUN conda config --set show_channel_urls true && \
    conda config --prepend channels conda-forge && \
    conda update --strict-channel-priority --yes -n base conda && \
    conda install --strict-channel-priority --yes --update-all --force-reinstall --file /tmp/requirements.txt && \
    jupyter labextension install @jupyter-widgets/jupyterlab-manager && \
    jupyter labextension install jupyter-leaflet && \
    conda clean --yes --all && \
    conda info --all && \
    conda list

# launch notebook in the local working directory that we mount
WORKDIR /home/jovyan/work

# set default command to launch when container is run
CMD ["jupyter", "lab", "--no-browser", "--NotebookApp.token=''", "--NotebookApp.password=''"]

# to test, import OSMnx and print its version
RUN python -c "import osmnx; print(osmnx.__version__)"
