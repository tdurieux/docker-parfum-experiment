FROM jupyter/minimal-notebook:dc9744740e12
MAINTAINER rowe@zatonovo.com

USER root
# Fix some apt issues
#RUN mkdir -p /var/lib/apt/lists/partial

# Add in requirements from opencpu/base
ENV DEBIAN_FRONTEND noninteractive

RUN \
  apt-get update && \
  #apt-get -y dist-upgrade && \
  apt-get install --no-install-recommends -qy software-properties-common && \
  add-apt-repository -y ppa:opencpu/opencpu-2.0 && \
  apt-get update && \
  apt-get install --no-install-recommends -qy opencpu-server x11-apps && rm -rf /var/lib/apt/lists/*;

# Prints apache logs to stdout
RUN \
  ln -sf /proc/self/fd/1 /var/log/apache2/access.log && \
  ln -sf /proc/self/fd/1 /var/log/apache2/error.log && \
  ln -sf /proc/self/fd/1 /var/log/opencpu/apache_access.log && \
  ln -sf /proc/self/fd/1 /var/log/opencpu/apache_error.log

# Set opencpu password so that we can login
RUN \
  echo "opencpu:opencpu" | chpasswd

# Apache ports
EXPOSE 80
EXPOSE 443
EXPOSE 8004


# Add in zatonovo toolchain
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN git clone https://github.com/muxspace/crant.git /app/crant
ENV PATH="$PATH:/app/crant"

RUN rpackage futile.logger futile.matrix \
  testit roxygen2 devtools reticulate formatR \
  https://github.com/zatonovo/lambda.r.git \
  https://github.com/zatonovo/lambda.tools.git

# For R jupyter notebook
RUN rpackage repr IRdisplay pbdZMQ uuid \
  https://github.com/IRkernel/IRkernel.git
RUN Rscript -e "IRkernel::installspec()"
RUN pip install --no-cache-dir numpy pandas scikit-learn

RUN mkdir /app/cache

# Start non-daemonized webserver
CMD apachectl -DFOREGROUND
