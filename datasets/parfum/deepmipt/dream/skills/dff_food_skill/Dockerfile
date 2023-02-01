FROM python:3.9.1
# ###################### IMMUTABLE SECTION ######################################
# Do not change anything in this section 
WORKDIR /src

COPY common/dialogflow_framework/requirements.txt .
RUN pip install -r requirements.txt

COPY common/dialogflow_framework/scripts /scripts

RUN bash /scripts/programy_logger_off.sh

# ###################### CUSTOM SECTION ######################################
# Here you can make changes

ARG SERVICE_NAME
ENV SERVICE_NAME ${SERVICE_NAME}

COPY skills/${SERVICE_NAME}/requirements.txt .
RUN pip install -r requirements.txt
RUN python -m spacy download en_core_web_sm

COPY skills/${SERVICE_NAME}/ ./
COPY ./common/ ./common/

ARG SERVICE_PORT
ENV SERVICE_PORT ${SERVICE_PORT}

# wait for a server answer ( INTERVAL + TIMEOUT ) * RETRIES seconds after that change stutus to unhealthy
HEALTHCHECK --interval=5s --timeout=5s --retries=3 CMD curl --fail 127.0.0.1:${SERVICE_PORT}/healthcheck || exit 1


CMD gunicorn --workers=1 server:app -b 0.0.0.0:${SERVICE_PORT}
