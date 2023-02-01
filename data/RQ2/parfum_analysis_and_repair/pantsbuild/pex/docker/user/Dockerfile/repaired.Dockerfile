# TODO(John Sirois): Use a fixed image once base is published to Docker Hub; ie: pantsbuild/pex:base
ARG BASE_ID
FROM ${BASE_ID}

# Prepare developer shim that can operate on local files and not mess up perms in the process.