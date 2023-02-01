FROM konduit-serving-with-conda

ARG NB_USER="jovyan"
USER $NB_USER

RUN pip install --no-cache-dir keras tensorflow numpy pillow

ARG NB_USER="jovyan"
USER $NB_USER
