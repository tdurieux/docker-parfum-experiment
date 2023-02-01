ARG WALL_E_BASE_ORIGIN_NAME

FROM $WALL_E_BASE_ORIGIN_NAME

ARG CONTAINER_HOME_DIR

ENV CONTAINER_HOME_DIR=$CONTAINER_HOME_DIR

WORKDIR $CONTAINER_HOME_DIR

COPY wall_e/src/requirements.txt .

RUN apk add --no-cache --update libffi-dev && \
    pip install --no-cache-dir -r requirements.txt && \
    apk --update --no-cache add postgresql-client
