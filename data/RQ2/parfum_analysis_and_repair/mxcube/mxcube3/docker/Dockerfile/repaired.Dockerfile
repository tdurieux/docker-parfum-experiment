##############################################################################
# Dockerfile to run MXCuBE web server
##############################################################################

FROM debian:10
MAINTAINER Marcus Oscarsson <marcus.oscarsson@esrf.fr>

ENV PATH /opt/conda/bin:$PATH
ENV TERM linux
ENV USER root

# Install system paackges
RUN apt-get update --fix-missing && apt-get -y upgrade && \
    DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y mate-desktop-environment-core && \
    apt-get install --no-install-recommends -y apt-utils curl git sudo build-essential wget \
    tightvncserver emacs xemacs21 vim procps && \
    apt-get install --no-install-recommends -y bzip2 ca-certificates libglib2.0-0 libxext6 libsm6 libxrender1 && rm -rf /var/lib/apt/lists/*;

RUN mkdir /root/.vnc && echo "mxcube" | vncpasswd -f > /root/.vnc/passwd && chmod 600 /root/.vnc/passwd
RUN touch /root/.Xresources && touch /root/.Xauthority

RUN \
  wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
  echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list && \
  apt-get update && \
  apt-get install --no-install-recommends -y google-chrome-stable && rm -rf /var/lib/apt/lists/*;

RUN wget --quiet https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
  /bin/bash ~/miniconda.sh -b -p /opt/conda && \
  rm ~/miniconda.sh

RUN echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
  echo "conda activate base" >> ~/.bashrc

RUN ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh

RUN conda init bash

WORKDIR /opt

# Install MXCuBE3
COPY conda-install.sh /opt/conda-install.sh
RUN cd /opt && chmod +x conda-install.sh && sync && ./conda-install.sh

COPY mxcube /usr/local/bin/
COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["/bin/bash"]

EXPOSE 8090 8081 5901
