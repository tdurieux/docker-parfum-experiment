FROM thewtex/krs-course:local

RUN python -m pip install git+https://github.com/data-8/nbgitpuller && \
  python -m jupyter serverextension enable --py nbgitpuller --sys-prefix

ADD LICENSE /home/jovyan/
ADD *.ipynb /home/jovyan/
ADD data /home/jovyan/data
ENV NB_UID 1000
USER root
RUN chown -R ${NB_UID}:users ${HOME}
USER $NB_USER
RUN rmdir /home/jovyan/work

CMD ["/usr/local/bin/start-singleuser.sh"]
