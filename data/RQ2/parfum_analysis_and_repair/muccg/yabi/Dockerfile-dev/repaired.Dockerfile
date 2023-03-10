#
FROM muccg/yabi-builder
LABEL maintainer "https://github.com/muccg/"

# At build time changing these args allow us to use a local devpi mirror
# Unchanged, these defaults allow pip to behave as noremal
ARG ARG_PIP_INDEX_URL="https://pypi.python.org/simple"
ARG ARG_PIP_TRUSTED_HOST="127.0.0.1"

# Runtime args
ENV DEPLOYMENT dev
ENV PRODUCTION 0
ENV DEBUG 1
ENV PIP_INDEX_URL $ARG_PIP_INDEX_URL
ENV PIP_TRUSTED_HOST $ARG_PIP_TRUSTED_HOST
ENV NO_PROXY ${PIP_TRUSTED_HOST}

# Strictly speaking not needed as we mount over the top
# However let's make it explicit that we don't want /app from the build image
RUN rm -rf /app && mkdir -p /app

# For dev we use root so we can shell in and do evil things
USER root
WORKDIR /app

RUN env | sort

COPY krb5.conf /etc/krb5.conf

# install python deps

# HACK yabi test requirements have this as a dep
COPY tests/SetupDjango-0.1.tar.gz /app/tests/SetupDjango-0.1.tar.gz

# Add our python deps in multiple docker layers
COPY yabish/requirements.txt /app/yabish/
RUN pip install --no-cache-dir --upgrade -r yabish/requirements.txt
COPY yabi/test-requirements.txt /app/yabi/
RUN pip install --no-cache-dir --upgrade -r yabi/test-requirements.txt
COPY yabi/dev-requirements.txt /app/yabi/
RUN pip install --no-cache-dir --upgrade -r yabi/dev-requirements.txt
COPY yabi/runtime-requirements.txt /app/yabi/
RUN pip install --no-cache-dir --upgrade -r yabi/runtime-requirements.txt

# Copy code and install the app
COPY . /app
RUN pip ${PIP_OPTS} install -e yabi
RUN pip ${PIP_OPTS} install -e yabish

EXPOSE 8000 9000 9001 9100 9101
VOLUME ["/app", "/data"]

# Allow celery to run as root for dev
ENV C_FORCE_ROOT=1
ENV HOME /data
WORKDIR /data

# entrypoint shell script that by default starts runserver
ENTRYPOINT ["/app/docker-entrypoint.sh"]
CMD ["runserver"]
