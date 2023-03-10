FROM jupyter/scipy-notebook:d113a601dbb8

WORKDIR /
USER root
# set local source.list
RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak
COPY ./linux_source/sources_ubuntu.list /etc/apt/sources.list

# r / rstudio server / shiny ------------------ 
COPY scripts /rocker_scripts

ENV R_HOME=/usr/lib/R
ENV R_LIB=/usr/local/lib/R/site-library
ENV CRAN=https://packagemanager.rstudio.com/all/__linux__/focal/latest
ARG CRAN_URL=https://mirrors.tuna.tsinghua.edu.cn/CRAN

ENV TERM=xterm
ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV TZ=Etc/UTC

ENV R_VERSION=4.0.3
ENV S6_VERSION=v2.1.0.2
ENV RSTUDIO_VERSION=1.4.1106
ENV PANDOC_VERSION=default

ENV PATH=${R_HOME}/bin:$PATH
ENV PATH=/usr/lib/rstudio-server/bin:$PATH

RUN /rocker_scripts/experimental/install_R_binary.sh

RUN /rocker_scripts/install_rstudio.sh && \
    /rocker_scripts/install_pandoc.sh && \
    install2.r --error --skipinstalled shiny rmarkdown && \
    /rocker_scripts/install_shiny_server.sh && \
    chown -R $NB_UID ${R_LIB} && \
    chmod -R 775 ${R_LIB}  && \
    chown $NB_UID:$NB_UID /srv/shiny-server/ && \
    chown $NB_UID:$NB_UID /var/lib/shiny-server && \
    chown $NB_UID:$NB_UID /var/log/shiny-server && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

ENV CTAN_REPO=http://mirror.ctan.org/systems/texlive/tlnet
ENV PATH=/usr/local/texlive/bin/x86_64-linux:$PATH
RUN /rocker_scripts/install_tidyverse.sh
RUN /rocker_scripts/install_verse.sh


# pkgs ------------------
# py pkgs
ENV RSESSION_PROXY_RSTUDIO_1_4=yes
RUN python3 -m pip install --upgrade https://github.com/jupyterhub/jupyter-rsession-proxy/tarball/master &&\
    python3 -m pip install -i https://pypi.tuna.tsinghua.edu.cn/simple --no-cache \
        rpy2 datatable \
        jupyter-shiny-proxy && \ 
        cd /opt/conda/lib/python3.8/site-packages/jupyter_shiny_proxy &&  \
        awk '{sub(/os.getcwd\(\)/,"\"/srv/shiny-server\"")}1' __init__.py > /tmp/temp.py && mv /tmp/temp.py __init__.py && \ 
        cd / && \
    rm -rf /tmp/* && \
    ## conda install
    conda install --quiet --yes \
        'jupyterhub=1.3.0' \
        'pyodbc' \
        'JayDeBeApi' && \
    conda clean --all -f -y && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

# r pkgs    
RUN R --quiet -e "install.packages(c('IRkernel'), repos='${CRAN_URL}')" 

# startup ------------------
RUN chown -R $NB_UID /etc/R && \
    chown -R $NB_UID /etc/rstudio
    
USER $NB_UID
# R startup 
# https://rviews.rstudio.com/2017/04/19/r-for-enterprise-understanding-r-s-startup/
RUN R --quiet -e "IRkernel::installspec()" && \
    echo 'options(repos = c(CRAN = "https://cran.rstudio.com/", CRANextra = "https://mirrors.tuna.tsinghua.edu.cn/CRAN"))' >> /etc/R/Rprofile.site && \
    echo "R_LIBS_SITE=${R_LIBS_SITE-'/usr/local/lib/R/site-library:/usr/lib/R/site-library:/usr/lib/R/library'}" >> /etc/R/Renviron.site && \
    echo 'RETICULATE_PYTHON = "/opt/conda/bin/python"' >> /etc/R/Renviron.site

# rstudio server config
RUN echo 'session-default-working-dir=/home/jovyan/work' >> /etc/rstudio/rsession.conf && \
    echo 'session-default-new-project-dir=/home/jovyan/work' >> /etc/rstudio/rsession.conf
COPY ./config/rstudio-prefs.json /etc/rstudio/rstudio-prefs.json
  
RUN mkdir -p /home/jovyan/share && \
    ln -s /home/jovyan/share /home/jovyan/work/share
    
WORKDIR $HOME
USER $NB_UID

# docker build -t shichenxie/dstudio_lab:dsrp -f Dockerfile_labds_rpy .

# fix openssl issue # https://github.com/tschaffter/rstudio/issues/1
# RUN conda remove --force -y openssl