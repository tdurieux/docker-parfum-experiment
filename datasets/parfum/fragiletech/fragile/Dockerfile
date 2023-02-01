FROM fragiletech/ubuntu20.04-cuda-11.0-py38
ARG JUPYTER_PASSWORD=fragile
ENV BROWSER=/browser \
    LC_ALL=en_US.UTF-8
COPY requirements-all.txt fragile/requirements-all.txt

# Install Python packages
RUN pip3 install -U pip && \
    cd fragile && \
    pip3 install --no-cache-dir -r requirements-all.txt --no-use-pep517 && \
    python3 -c "import matplotlib; matplotlib.use('Agg'); import matplotlib.pyplot"

COPY . fragile/

RUN cd fragile && pip3 install -e .["all"] --no-use-pep517

# Remove dev packages
RUN pip3 uninstall -y cython && \
    apt-get remove -y cmake pkg-config flex bison curl libpng-dev \
        libjpeg-turbo8-dev zlib1g-dev libhdf5-dev libopenblas-dev gfortran \
        libfreetype6-dev libjpeg8-dev libffi-dev && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /root/.jupyter && \
    echo 'c.NotebookApp.token = "'${JUPYTER_PASSWORD}'"' > /root/.jupyter/jupyter_notebook_config.py
CMD jupyter notebook --allow-root --port 8080 --ip 0.0.0.0