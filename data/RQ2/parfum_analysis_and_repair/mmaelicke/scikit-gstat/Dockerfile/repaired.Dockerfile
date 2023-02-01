# specify a default Python version
ARG PYTHON_VERSION=3.8

# build from Python
FROM python:${PYTHON_VERSION}
LABEL maintainer="Mirko Mälicke"

# set a user
RUN adduser skguser
USER skguser
WORKDIR /home/skguser

# copy the tutorial
RUN mkdir tutorials
COPY --chown=skguser:skguser ./tutorials ./tutorials

# set the path
ENV PATH="/home/skguser/.local/bin:${PATH}"

# install scikit-gstat
RUN pip install --no-cache-dir scikit-gstat

# install optional dependencies
RUN pip install --no-cache-dir gstools pykrige
RUN pip install --no-cache-dir plotly
RUN pip install --no-cache-dir rise
RUN pip install --no-cache-dir jupyter

# open port 8888
EXPOSE 8888

CMD jupyter notebook --ip "0.0.0.0"