ARG BASE_IMAGE

# ================
# Build virtualenv
# ================
FROM ${BASE_IMAGE} AS python-environment

ENV TMPDIR=/var/tmp
ENV PIP_EXTRA_INDEX_URL=https://packages.hiveeyes.org/hiveeyes/python/eggs/

ARG venv=/venv
ARG pip=${venv}/bin/pip
ARG python=${venv}/bin/python


# Create Python virtualenv
RUN virtualenv --system-site-packages --always-copy --python=python ${venv}

# Remove superfluous "local" folder inside virtualenv
# See also:
# - http://stackoverflow.com/questions/8227120/strange-local-folder-inside-virtualenv-folder
# - https://github.com/pypa/virtualenv/pull/166
# - https://github.com/pypa/virtualenv/commit/5cb7cd652953441a6696c15bdac3c4f9746dfaa1
RUN rm -rf ${venv}/local

#RUN $pip install setuptools --upgrade --force-reinstall
#RUN $pip install setuptools==18.8.1 --upgrade --force-reinstall
#RUN $pip install setuptools==22.0.5 --upgrade --force-reinstall

# Downgrade pip due to "BackendUnavailable" error with pip >= 19.0.0
RUN $pip install pip==18.1 --upgrade --force-reinstall

# Install "virtualenv-tools" for relocating the virtualenv
RUN $pip install virtualenv-tools==1.0  # --upgrade --force-reinstall

RUN $pip install pandas==0.18.1
RUN $pip install 'https://github.com/jjmalina/pyinfluxql/tarball/d92db4ab8c#egg=pyinfluxql-0.0.1'



# ===============
# Acquire sources
# ===============
FROM python-environment AS acquire-sources

ARG SOURCES=/sources

RUN \
    mkdir -p $SOURCES && \
    git clone --depth=1 https://github.com/daq-tools/kotori.git $SOURCES



# ======================
# Install Python package
# ======================

FROM acquire-sources AS install-kotori

ENV TMPDIR=/var/tmp
ENV PIP_EXTRA_INDEX_URL=https://packages.hiveeyes.org/hiveeyes/python/eggs/

ARG VERSION
ARG FEATURES

ARG SOURCES=/sources

ARG venv=/venv
ARG pip=${venv}/bin/pip
ARG python=${venv}/bin/python


# TODO: Make this optionally.
#COPY Makefile $SOURCES/Makefile
#COPY setup.py $SOURCES/setup.py
#COPY pyproject.toml $SOURCES/pyproject.toml
#COPY MANIFEST.in $SOURCES/MANIFEST.in

WORKDIR $SOURCES

RUN $python setup.py sdist

# Install Kotori and its dependencies
RUN $pip install kotori[${FEATURES}]==${VERSION} --find-links=./dist --upgrade


# ----

# 3.a Install from local sdist egg, enabling extra features
# TODO: Maybe use "--editable" for installing in development mode
# TODO: Build Wheels: https://pip.pypa.io/en/stable/reference/pip_wheel/
#@#TMPDIR=/var/tmp $(buildpath)/bin/pip install kotori[$(features)]==$(version) --download-cache=./build/pip-cache --find-links=./dist --process-dependency-links

# 3.b Install from egg on package server
# https://pip.pypa.io/en/stable/reference/pip_wheel/#cmdoption--extra-index-url
#TMPDIR=/var/tmp $(buildpath)/bin/pip install kotori[$(features)]==$(version) --process-dependency-links --extra-index-url=https://packages.elmyra.de/elmyra/foss/python/


# ----


# ===========================
# Create distribution package
# ===========================
# Todo: Decouple this task from the repository.
#       Q: Where to place the resources from the "packaging" folder then?
#       A: TBD.

FROM install-kotori AS package-kotori

ENV TMPDIR=/var/tmp

ARG NAME
ARG VERSION
ARG FEATURES

ARG SOURCES=/sources

ARG venv=/venv
ARG pip=${venv}/bin/pip
ARG python=${venv}/bin/python


COPY packaging/builder/fpm-package $SOURCES/fpm-package

WORKDIR $SOURCES

# Counter "ValueError: bad marshal data (unknown type code)"
# coming from manipulation through "virtualenv-tools"".
RUN find ${venv} -name '*.pyc' -delete

# Relocate the virtualenv by updating the python interpreter in the shebang of installed scripts.
RUN ${venv}/bin/virtualenv-tools --update-path=/opt/kotori ${venv}

# Build package.
RUN ./fpm-package "${NAME}" "${VERSION}"
