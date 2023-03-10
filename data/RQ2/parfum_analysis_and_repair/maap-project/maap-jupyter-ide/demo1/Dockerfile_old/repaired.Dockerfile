FROM jupyter/base-notebook:137a295ff71b
#FROM jupyterhub/singleuser:0.9

# Install jupyterlab
RUN conda install -c conda-forge jupyterlab=0.34
RUN jupyter serverextension enable --py jupyterlab --sys-prefix

USER root

# Install ssh-client
RUN apt-get update -y && apt install --no-install-recommends openssh-client -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get autoremove -y
RUN mkdir /var/run/sshd

RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

#RUN adduser --disabled-password newuser
WORKDIR /usr/jovyan/

# Install search extension
COPY search/ $WORKDIR/search
RUN cd $WORKDIR/search && npm run build
#RUN cd $WORKDIR/search && rm package-lock.json && rm package.json
RUN cd $WORKDIR/search && rm package.json
COPY search/package.json $WORKDIR/search/package.json
#RUN cd $WORKDIR/search && jupyter labextension link .
RUN cd $WORKDIR/search && npm i jquery && jupyter labextension link . && npm cache clean --force;
RUN cd $WORKDIR/search && pip install --no-cache-dir -e .

RUN cd $WORKDIR/search/search/maap-py && python setup.py install
RUN cd $WORKDIR/search && jupyter serverextension enable --py search --sys-prefix

#RUN useradd -ms /bin/bash ubuntu
#USER ubuntu
EXPOSE 8888
EXPOSE 22

COPY --chown=root:root jlab.sh ./jlab.sh
ENTRYPOINT ["/bin/bash", "./jlab.sh"]
