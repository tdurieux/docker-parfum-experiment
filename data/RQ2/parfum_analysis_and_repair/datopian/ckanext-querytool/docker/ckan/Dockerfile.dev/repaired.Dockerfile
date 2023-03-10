FROM openknowledge/ckan-dev:2.7

MAINTAINER Viderum <info@Viderum.com>

# Install utilities
RUN pip install --no-cache-dir ipdb ipdbplugin

# Install any extensions needed by your CKAN instance
# (Make sure to add the plugins to CKAN__PLUGINS in the .env file)
# TODO: pin when possible
RUN echo 'Installing extensions' && \
    # geoview
    pip install --no-cache-dir -e git+https://github.com/okfn/ckanext-geoview.git@#egg=ckanext-geoview && \
    pip install --no-cache-dir -r https://raw.githubusercontent.com/okfn/ckanext-geoview/master/pip-requirements.txt && \
    # querytool
    pip install --no-cache-dir -e git+https://github.com/ViderumGlobal/ckanext-querytool.git#egg=ckanext-querytool && \
    pip install --no-cache-dir -r https://raw.githubusercontent.com/ViderumGlobal/ckanext-querytool/master/requirements.txt

# Apply patches
COPY patches ${APP_DIR}/patches
RUN git config --global user.email "autopatcher@okfn.org" && \
    git config --global user.name "autopatcher" && \
    cd $SRC_DIR/ckan && \
    for f in $APP_DIR/patches/ckan/*.patch; do echo "$0: Applying patch $f"; git apply "$f" ; done

# Copy config files
COPY crontabs/* /etc/crontabs/
COPY docker-entrypoint.d/* /docker-entrypoint.d/
COPY supervisor.d/* /etc/supervisord.d/
