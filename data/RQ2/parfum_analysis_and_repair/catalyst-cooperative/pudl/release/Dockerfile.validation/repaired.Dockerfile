# TODO(rousik): this docker image should contain validation logic to be
# run on the data packages that will be mounted to /pudl/outputs.

# Look into pudl-data-release repo and the release script on how to construct
# this.
FROM pudl-release
RUN conda install --yes pytest tox

# TODO(rousik): we need to do datapkg_to_sqlite and epacems_to_parquet before
# running tox.