FROM "__FROM_IMAGE_STREAM_DEFINED_IN_TEMPLATE__"

# Install project dependencies
COPY requirements.txt ${APP_ROOT}/src
RUN source /opt/app-root/etc/scl_enable && \
    set -x && \
    pip install --no-cache-dir -U pip setuptools wheel && \
    cd ${APP_ROOT}/src && pip install --no-cache-dir -r requirements.txt
