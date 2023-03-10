FROM jupyterhub/jupyterhub

RUN pip3 install --no-cache-dir --no-cache jupyterlab notebook nbgitpuller matplotlib tensorflow \
  torch torchvision torchaudio torchtext \
  ipywidgets beakerx \
  bash_kernel nodejs

RUN curl -f -sSL https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -o /tmp/miniconda.sh && \
    bash /tmp/miniconda.sh -bfp /usr/local && rm -rf /tmp/miniconda.sh && \
    conda install -y python=3 && conda update conda && conda clean --all --yes

RUN conda install -c conda-forge -c pytorch -c krinsman xeus-cling ijavascript && \
    conda clean --all --yes && \
    npm install -g --unsafe-perm ijavascript && ijsinstall --hide-undefined --install=global && npm cache clean --force

RUN apt-get update -yqq && \ 
    echo "--------------------------------------" && \
    echo "----------- JULIA INSTALL ------------" && \
    echo "--------------------------------------" && \
    apt-get install --no-install-recommends -yq julia && \

    apt-get -y autoclean && apt-get -y autoremove && \
    apt-get -y purge $(dpkg --get-selections | grep deinstall | sed s/deinstall//g) && \
    rm -rf /var/lib/apt/lists/* /tmp/*

#Julia
RUN echo "--------------------------------------" && \
    echo "----------- JULIA LINK TO JUPYTER ----" && \
    echo "--------------------------------------" && \
    julia -e 'empty!(DEPOT_PATH); push!(DEPOT_PATH, "/usr/share/julia"); using Pkg; Pkg.add("IJulia")'  && \
    cp -r /root/.local/share/jupyter/kernels/julia-* /usr/local/share/jupyter/kernels/  && \
    chmod -R +rx /usr/share/julia/  && \
    chmod -R +rx /usr/local/share/jupyter/kernels/julia-*/

#Add Extentions
#RUN jupyter labextension install jupyterlab-drawio
RUN jupyter labextension install @wallneradam/run_all_buttons
RUN jupyter labextension install jupyterlab-spreadsheet

ADD settings/jupyter_notebook_config.py /etc/jupyter/
ADD settings/jupyterhub_config.py /etc/jupyterhub/
COPY scripts /scripts

RUN chmod -R 755 /scripts

CMD "/scripts/sys/init.sh"
