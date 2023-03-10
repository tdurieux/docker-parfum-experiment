FROM edrixs/edrixs_base
WORKDIR /project

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections \
    && apt-get update \
    && apt-get install -y -q --no-install-recommends curl \
    && curl -f -sL https://deb.nodesource.com/setup_10.x | sudo -E bash - \
    && apt install --no-install-recommends -y git nodejs \
       texlive-xetex texlive-fonts-recommended texlive-plain-generic \
       ffmpeg dvipng cm-super pandoc \
    && pip install --no-cache-dir ipympl==0.5.* \
    # Also activate ipywidgets extension for JupyterLab
    && jupyter nbextension enable --py widgetsnbextension --sys-prefix \
    # Check this URL for most recent compatibilities
    # https://github.com/jupyter-widgets/ipywidgets/tree/master/packages/jupyterlab-manager
    && jupyter labextension install @jupyter-widgets/jupyterlab-manager@^2.0.0 --no-build \
    && jupyter labextension install @bokeh/jupyter_bokeh@^2.0.0 --no-build \
    && jupyter labextension install jupyter-matplotlib@^0.7.2 --no-build \
    && jupyter lab build -y \
    && jupyter lab clean -y && rm -rf /var/lib/apt/lists/*;

    # Get edrixs
RUN git clone https://github.com/NSLS-II/edrixs.git \
    && mkdir src \
    && cp -r edrixs src/

    # build fortran part of edrixs
RUN export LD_LIBRARY_PATH="/usr/local/lib:\$LD_LIBRARY_PATH" \
    && make -C src/edrixs/src F90=mpif90 LIBS="-L/usr/local/lib -lopenblas -lparpack -larpack" \
    && make install -C src/edrixs/src \
    # build python part of edrixs
    && cd src/edrixs \
    && python setup.py build_ext --library-dirs=/usr/local/lib \
    && pip install --no-cache-dir . \
    && cd ../../ \
    # set env
    && echo "export PATH=/project/src/edrixs/bin:\$PATH" >> ~/.bashrc \
    && echo "export PATH=/project/src/edrixs/bin:\$PATH" >> /home/rixs/.bashrc \
    # copy examples to /home/rixs
    && cp -r src/edrixs/examples /home/rixs/edrixs_examples \
    && chown -R rixs:rixs /home/rixs/edrixs_examples

CMD jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root
