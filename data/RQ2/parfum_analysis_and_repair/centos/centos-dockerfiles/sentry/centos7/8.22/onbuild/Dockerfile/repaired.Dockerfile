FROM sentry:8.22

WORKDIR /usr/src/sentry

# Add WORKDIR to PYTHONPATH so local python files don't need to be installed
ENV PYTHONPATH /usr/src/sentry
ONBUILD COPY . /usr/src/sentry

# Hook for installing additional plugins
 \
RUN if [ -s requirements.txt ]; then \
 pip install --no-cache-dir -r requirements.txt; fiONBUILD

# Hook for installing a local app as an addon
 \
RUN if [ -s setup.py ]; then \
 pip install --no-cache-dir -e .; fiONBUILD

# Hook for staging in custom configs
ONBUILD RUN if [ -s sentry.conf.py ]; then cp sentry.conf.py $SENTRY_CONF/; fi \
	&& if [ -s config.yml ]; then cp config.yml $SENTRY_CONF/; fi
