# Get base
ARG BASE

# Get baseline
FROM quay.io/pypa/${BASE}

# Get base
ARG BASE

# Get Python version
ARG PYTHON

# Set default if needed
ENV PYTHON=${PYTHON:-cp37-cp37m}

# Update PATH
ENV PATH=/opt/python/${PYTHON}/bin/:$PATH

# Copy HybridQ
COPY ./ /opt/hybridq

# Remove git repository from requirements
RUN sed -i '/git+https/d' /opt/hybridq/requirements.txt

# Create wheel
RUN mkdir /tmp/hybridq && \
    ARCH=core-avx2 pip wheel --no-dependencies -v /opt/hybridq -w /tmp/hybridq

# Rename wheel