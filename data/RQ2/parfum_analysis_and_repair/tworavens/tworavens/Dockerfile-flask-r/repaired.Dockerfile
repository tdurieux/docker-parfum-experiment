FROM tworavens/r-service-base-py:latest
MAINTAINER TwoRavens http://2ra.vn/

LABEL organization="Two Ravens" \
      2ra.vn.version="0.5-alpha" \
      2ra.vn.release-date="2019-09-20" \
      description="Image for the Two Ravens R service which runs on rook."

# -------------------------------------
# Copy the repo over
#   - future: ignore the tworavens django dirs
#     and assets, be more selective
# -------------------------------------
RUN mkdir -p /var/webapps/TwoRavens && \
    mkdir -p /var/webapps/TwoRavens/assets && \
    mkdir -p /ravens_volume

# -------------------------------------
# Copy over the requirements and run them (flask has own dependencies
# -------------------------------------
COPY ./requirements/ ./requirements
RUN pip install --no-cache-dir -r requirements/flask-prod.txt


# Copy over selected files
#
COPY ./R /var/webapps/TwoRavens/R
COPY ./LICENSE /var/webapps/TwoRavens
COPY ./README.md /var/webapps/TwoRavens


# -------------------------------------
# Set production environment variable
# -------------------------------------
ENV FLASK_USE_PRODUCTION_MODE=True

# -------------------------------------
# Create a volume for outside info
# -------------------------------------
VOLUME /ravens_volume

# -------------------------------------
# Expose port for the web (rook)
# -------------------------------------
EXPOSE 8000

WORKDIR /var/webapps/TwoRavens/R

# -------------------------------------
# Run flask with "rook_nonstop.R"
# -------------------------------------
#fab run_R
CMD python runner.py

# -----------------------------------------
# -- Dev notes --
#
# build local:
# > docker build -t tworavens/ravens-r-service:sept-2019 -f Dockerfile-flask-r  .
#
# shell access:
# > docker run -ti --rm --name rook-shell -p 8000:8000 tworavens/ravens-r-service:sept-2019 /bin/bash
#
# run app
# > docker run -ti --rm --name rook-test -e FLASK_USE_PRODUCTION_MODE="yes" -p8000:8000 -v /ravens_volume:/ravens_volume  tworavens/ravens-r-service:sept-2019
#
# log into running app
# > docker exec -ti rook-test /bin/bash
#

# -----------------------------------------