ARG PYTHON_VERSION
FROM python:$PYTHON_VERSION

# Copy SDK code into the container
RUN mkdir -p $HOME/py-algorand-sdk
COPY . $HOME/py-algorand-sdk
WORKDIR $HOME/py-algorand-sdk

# SDK dependencies, and source version of behave with tag expression support
RUN pip install --no-cache-dir . -q \
    && pip install --no-cache-dir -r requirements.txt -q

# Run integration tests
CMD ["/bin/bash", "-c", "make unit && make integration"]

