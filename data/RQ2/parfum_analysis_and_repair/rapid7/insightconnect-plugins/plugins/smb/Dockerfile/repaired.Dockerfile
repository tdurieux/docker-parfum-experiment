FROM komand/python-3-37-slim-plugin:3
LABEL organization=komand
LABEL sdk=python
LABEL type=plugin

# Add source code
WORKDIR /python/src
ADD ./plugin.spec.yaml /plugin.spec.yaml
ADD . /python/src

# Install pip dependencies
RUN if [ -f requirements.txt ]; then \
 pip install --no-cache-dir -r requirements.txt; fi

# Install plugin
RUN python setup.py build && python setup.py install

ENTRYPOINT ["/usr/local/bin/komand_smb"]
