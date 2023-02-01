# Set the base image to the base image
FROM hmlandregistry/dev_base_python_flask:4

# Uncomment if app will be using a database
# ---- Database stuff start
RUN yum install -y -q postgresql-devel && rm -rf /var/cache/yum
ENV SQL_HOST postgres
# This must match the database created in postgres-init-fragment:
ENV SQL_DATABASE gadgetdb
# This is the root user specified in the postgres Dockerfile:
ENV ALEMBIC_SQL_USERNAME root
# (This will be temporarily overidden to yes when the alembic database upgrade is run)
ENV SQL_USE_ALEMBIC_USER no
# The following entries must match the user created in the fragments/postgres-init-fragment.sql:
ENV APP_SQL_USERNAME gadgetuser
# (This will be temporarily overidden to be the root password when the alembic database upgrade is run)
ENV SQL_PASSWORD gadgetpassword
# ---- Database stuff end

# ----
# Put your app-specific stuff here
# Needed for health route if using HMLR Flask skeleton
ENV APP_NAME="my-app-api" \
 MAX_HEALTH_CASCADE="6" \
 LOG_LEVEL="DEBUG"

# ----

# The CMD to run the app is inherited from dev_base_python_flask
# (if following HMLR Flask skeleton) otherwise add your own here

# Get the python environment ready
# Have this at the end so if the files change, all the other steps
# don't need to be rerun. Same reason why _test is first.
ADD requirements_test.txt requirements_test.txt
ADD requirements.txt requirements.txt
RUN pip3 install --no-cache-dir -q -r requirements.txt && \
  pip3 install --no-cache-dir -q -r requirements_test.txt
