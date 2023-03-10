FROM komand/python-3-plugin
# The three supported python parent images are:
# - komand/python-2-plugin
# - komand/python-3-plugin
# - komand/python-pypy3-plugin
#
# Update the tag to a full semver version

# Add any custom package dependencies here
# NOTE: Add pip packages to requirements.txt
RUN apt-get update -y && apt-get install --no-install-recommends -y libffi6 libffi-dev && rm -rf /var/lib/apt/lists/*;

# End package dependencies

# Add source code
WORKDIR /python/src
ADD ./plugin.spec.yaml /plugin.spec.yaml
ADD . /python/src

# Install pip dependencies
RUN if [ -f requirements.txt ]; then \
 pip install --no-cache-dir -r requirements.txt; fi

# Install plugin
RUN python setup.py build && python setup.py install

ENTRYPOINT ["/usr/local/bin/komand_carbon_black_live_response"]