#+++++++++++++++++++++++++++++++++++++++
# Dockerfile for webdevops/sphinx:latest
#    -- automatically generated  --
#+++++++++++++++++++++++++++++++++++++++

FROM webdevops/bootstrap:alpine

RUN set -x \
    && apk-install \
    # General python
    python \
    py-crypto \
    py2-pip \
    # General sphinx
    py-pillow \
    py-yaml \
    py-sphinx \
    py-sphinx_rtd_theme \
    # GRAPHVIZ
    graphviz \
    ttf-dejavu \
    && pip install --no-cache-dir --upgrade pip \
    && hash -r \
    && pip install --no-cache-dir --upgrade sphinxcontrib-googlechart \
    && pip install --no-cache-dir --upgrade sphinxcontrib-googlemaps \
    && pip install --no-cache-dir --upgrade sphinxcontrib-httpdomain \
    && pip install --no-cache-dir --upgrade sphinxcontrib-slide \
    && pip install --no-cache-dir --upgrade sphinx-autobuild \
    && pip install --no-cache-dir --upgrade recommonmark \
    # TYPO3 stuff
    && pip install --no-cache-dir t3SphinxThemeRtd \
    && pip install --no-cache-dir t3fieldlisttable \
    && pip install --no-cache-dir t3tablerows \
    && pip install --no-cache-dir t3targets \
    && docker-run-bootstrap \
    && docker-image-cleanup
