FROM ucbjey/risecamp2018-base

# use apt-get as user "root" to install ubuntu packages
USER root
RUN apt-get update
RUN apt-get install -y g++ git daemon
RUN cd /tmp && git clone https://github.com/immesys/pywave
COPY support/prestart.sh /usr/local/bin/start-notebook.d
COPY support/waved /usr/local/bin
COPY support/wave.toml /usr/local/bin
ENV JUPYTER_ENABLE_LAB=1
# use "$NB_USER" when installing python packages
USER $NB_USER
RUN pip install bokeh==0.13.0
RUN cd /tmp/pywave && pip install .
RUN pip install paho-mqtt

# copy the tutorial into the container.
# do this last so that your container builds are as fast as possible
# when updating the content in tutorial/
COPY tutorial /home/$NB_USER/

# configure httpd
USER root
COPY nginx.conf /etc/nginx/sites-enabled/default
