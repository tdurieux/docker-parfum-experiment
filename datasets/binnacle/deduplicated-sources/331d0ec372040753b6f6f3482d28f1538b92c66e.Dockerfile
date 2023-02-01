FROM jupyter/minimal-notebook

MAINTAINER Austin Rochford <austin.rochford@gmail.com>

USER root

# install libav-tools to support matplotlib animations
RUN apt-get update && \
    apt-get install -y --no-install-recommends libav-tools && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

USER $NB_USER

COPY create_testenv.sh /tmp/create_testenv.sh
RUN /bin/bash /tmp/create_testenv.sh --global --no-setup

#  matplotlib nonsense
ENV XDG_CACHE_HOME /home/$NB_USER/.cache/
ENV MPLBACKEND=Agg
# for prettier default plot styling
RUN pip3 install seaborn
# Import matplotlib the first time to build the font cache.
RUN python -c "import matplotlib.pyplot"

ENV PYTHONPATH $PYTHONPATH:"$HOME"/pymc3
