FROM komand/python-3-37-plugin:3
# Refer to the following documentation for available SDK parent images: https://docs.rapid7.com/insightconnect/sdk-guide/#sdk-guide
#
LABEL organization=rapid7
LABEL sdk=python

# Add any custom package dependencies here
# NOTE: Add pip packages to requirements.txt

# End package dependencies

# Add source code
WORKDIR /python/src
ADD ./plugin.spec.yaml /plugin.spec.yaml
ADD . /python/src

# Install pip dependencies
RUN if [ -f requirements.txt ]; then \
 pip install --no-cache-dir -r requirements.txt; fi

RUN apt-get update; apt-get -y --no-install-recommends install chromium chromedriver; rm -rf /var/lib/apt/lists/*; apt-get clean

# Install plugin
RUN python setup.py build && python setup.py install

# User to run plugin code. The two supported users are: root, nobody
USER nobody

ENTRYPOINT ["/usr/local/bin/icon_url_screenshot"]
