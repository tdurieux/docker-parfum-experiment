# Note: This only runs the Django app, not the rook services
FROM python:3.6.8
MAINTAINER TwoRavens http://2ra.vn/

LABEL organization="Two Ravens" \
      2ra.vn.version="0.0.6-eventdata" \
      2ra.vn.release-date="2021-01-20" \
      description="Event Data exploration."

# -------------------------------------
# Install sqlite + debugging tools
# -------------------------------------
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    apt-utils \
    iputils-ping \
    telnet \
    sqlite3 \
    vim && rm -rf /var/lib/apt/lists/*;

# -------------------------------------
# Set the workdir
# -------------------------------------
WORKDIR /var/webapps/TwoRavens

# -------------------------------------
# Copy over the requirements and run them
# -------------------------------------
COPY ./requirements/ ./requirements
RUN pip3 install --no-cache-dir -r requirements/prod-eventdata.txt

# -------------------------------------
# Copy over the rest of the repository
# -------------------------------------
COPY . .

# -------------------------------------
# Set some environment variables
#   (This can be overridden in docker compose/kubernetes)
#
# - DJANGO_SETTINGS_MODULE: Django settings
# - R_DEV_SERVER_BASE - rook-service docker container
# - TA2_STATIC_TEST_MODE: True: use canned responses instead of a TA2 server
# - TA2_TEST_SERVER_URL - TA2 test server
# - CODE_REPOSITORY - repository where code will be copied
# -------------------------------------
ENV DJANGO_SETTINGS_MODULE=tworavensproject.settings.dev_container2 \
    R_DEV_SERVER_BASE=http://rook-service:8000/ \
    TA2_STATIC_TEST_MODE=True \
    CODE_REPOSITORY=/var/webapps/TwoRavens \
    SESSION_COOKIE_NAME=tworavens_eventdata \
    CSRF_COOKIE_NAME=tworavens_eventdata_csrf \
    LC_ALL=C.UTF-8

# -------------------------------------
# Create a volume for sharing between containers
# -------------------------------------
VOLUME /ravens_volume

# -------------------------------------
# Run setup scripts
#   - init_db - creates sqlite db for test run with
#
#   - create_django_superuser - Admin user created for testing
#
#   - create_test_user - Non-admin user created for testing
#
#   - load_eventdata_prod - sets JS variables for UI Event Data
#
#   - collect_static - django collect static files
#
# -------------------------------------
#RUN fab init_db && \
#    fab create_django_superuser && \
#    fab create_test_user  && \
#    fab load_eventdata_prod && \
#    fab collect_static

# -------------------------------------
# Expose port for web communication
# - web: 8080
# -------------------------------------
EXPOSE 8080

# -------------------------------------
# Copy the event data start command
# -------------------------------------
COPY startup_script/event_data_start.sh /usr/bin/event_data_start.sh

RUN chmod u+x /usr/bin/event_data_start.sh

# -------------------------------------
# Idle the container on startup so it
# can receive subsequent commands
# -------------------------------------
ENTRYPOINT tail -f /dev/null

#CMD echo 'Starting TwoRavens python server.' && \
#    cp -r ravens_volume/. /ravens_volume/ && \
#    python manage.py runserver 0.0.0.0:8080
