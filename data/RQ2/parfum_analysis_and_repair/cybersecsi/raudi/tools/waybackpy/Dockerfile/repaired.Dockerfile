# Base Distro Arg
ARG PYTHON_ALPINE_VERSION

FROM python:$PYTHON_ALPINE_VERSION

# Build Args
ARG WAYBACKPY_PIP_VERSION

# Content
RUN pip install --no-cache-dir waybackpy==$WAYBACKPY_PIP_VERSION
ENTRYPOINT ["waybackpy"]