# this installs the complete server. for development, only the jupyter backend will be used
FROM jupyter/pyspark-notebook
# install node server for app
USER root
RUN mkdir /srv/app
RUN mkdir /srv/app/logs
COPY ./appserver /srv/app
COPY ./app/dist /srv/app/dist
WORKDIR /srv/app

COPY ./appserver/start.sh /srv/app
RUN chmod +x /srv/app/start.sh
RUN chown -R jovyan:users /srv/app
RUN npm install -g forever && npm cache clean --force;

USER jovyan
RUN npm install && npm cache clean --force;

# add jupyter headless server
RUN pip install --no-cache-dir jupyter_server
RUN pip install --no-cache-dir jupyter-console
ENV PYTHONPATH "${PYTHONPATH}:/opt/basin/lib"
COPY ./app/lib /opt/basin/lib
COPY ./appserver/config/jupyter_server_config.py $HOME/.jupyter/jupyter_server_config.py
CMD ["./start.sh"]
