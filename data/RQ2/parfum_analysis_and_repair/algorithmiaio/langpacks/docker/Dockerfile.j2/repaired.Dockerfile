FROM ubuntu:16.04

# Install base packages that would be needed for any builder or runner
RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    apt-get -y --no-install-recommends install software-properties-common && \
    add-apt-repository -y ppa:george-edison55/cmake-3.x && \
    apt-get update && \
    apt-get -y --no-install-recommends install \
        autoconf \
        automake \
        build-essential \
        cmake \
        curl \
        fontconfig \
        fonts-wqy-microhei \
        gcc-4.8 \
        gcc-4.8-multilib \
        g++-4.8 \
        g++-4.8-multilib \
        gfortran \
        # For installing packages hosted via github
        git-core \
        libatlas-base-dev \
        libblas-dev \
        libfreetype6-dev \
        # For including gdal.h (geo-spatial data)
        libgdal-dev \
        libjasper-dev \
        libjpeg-dev \
        libjpeg8-dev \
        liblapack-dev \
        libmagickwand-dev \
        libopenblas-dev \
        libpng-dev \
        libssl-dev \
        libtbb-dev \
        libtiff-dev \
        # For X11/X11lib.h
        libx11-dev \
        pandoc \
        pkg-config \
        unzip \
        texlive \
        wget \
        zip && \
    rm -rf /var/lib/apt/lists/*

# Set options that should be defined everywhere
ENV JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF8
ENV LANG C.UTF-8

RUN adduser --disabled-password --gecos "" --uid {{algo_uid}} algo

{% for library in libraries %}
# --------
# Install {{library.name}}
  {% for file in library.files %}
ADD libraries/{{ library.name }}/{{file}} /opt/algorithmia/setup/{{library.name}}/{{file}}
  {% endfor %}
  {% for script in library.install_scripts %}
ADD libraries/{{ library.name }}/{{script}} /opt/algorithmia/setup/{{library.name}}/{{script}}
RUN /opt/algorithmia/setup/{{ library.name }}/{{script}} && rm -rf /var/lib/apt/lists/*
  {% endfor %}
  {% for name, value in library.env_variables.items()|sort %}
ENV {{name}}={{value}}
  {% endfor %}
{% endfor %}
# --------

# Add langserver binary and algorithm directory
RUN mkdir /opt/algorithm && chown algo /opt/algorithm
ADD bin/init-langserver /bin/
ADD target/release/langserver /bin/
USER algo
