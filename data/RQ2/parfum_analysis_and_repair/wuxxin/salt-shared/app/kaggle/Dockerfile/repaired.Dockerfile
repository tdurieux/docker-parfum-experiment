FROM gcr.io/kaggle-images/python

ADD clean-layer.sh  /tmp/clean-layer.sh

RUN pip install --no-cache-dir jupyter_contrib_nbextensions && \
    pip install --no-cache-dir jupyter_nbextensions_configurator && \
    pip install --no-cache-dir python-language-server[all] && \
    pip install --no-cache-dir jupyterlab && \
    pip install --no-cache-dir jupyterlab-lsp && \
    pip install --no-cache-dir auto-sklearn && \
    /tmp/clean-layer.sh
