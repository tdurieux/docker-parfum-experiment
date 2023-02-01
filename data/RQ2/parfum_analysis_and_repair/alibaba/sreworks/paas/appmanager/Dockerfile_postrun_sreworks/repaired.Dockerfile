FROM sw-postrun:latest
COPY ./APP-META-PRIVATE/postrun /app/postrun
ENV SREWORKS_INIT "enable"
RUN pip install --no-cache-dir requests requests_oauthlib
RUN rm -rf /app/postrun/00_init_app_manager_flow.py && \
    apk update && \
    apk add --no-cache wget bind-tools