FROM komand/python-3-37-plugin:3
LABEL organization=komand

# Add any custom package dependencies here
# NOTE: Add pip packages to requirements.txt

# End package dependencies
RUN apt-get update && apt-get install --no-install-recommends foremost -y && rm -rf /var/lib/apt/lists/*;
# Add source code
WORKDIR /python/src
ADD ./plugin.spec.yaml /plugin.spec.yaml
ADD . /python/src

# Install pip dependencies
RUN if [ -f requirements.txt ]; then \
 pip install --no-cache-dir -r requirements.txt; fi

# Install plugin
RUN python setup.py build && python setup.py install

USER root

ENTRYPOINT ["/usr/local/bin/komand_foremost"]