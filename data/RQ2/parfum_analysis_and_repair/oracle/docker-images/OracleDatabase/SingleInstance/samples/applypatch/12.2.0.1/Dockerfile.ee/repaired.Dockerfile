# LICENSE UPL 1.0
#
# Copyright (c) 1982-2017 Oracle and/or its affiliates. All rights reserved.
#
# ORACLE DOCKERFILES PROJECT
# --------------------------
# This is the Dockerfile for a patched Oracle Database 12c Release 1 Enterprise Edition
# 
# REQUIREMETNS FOR THIS IMAGE
# ----------------------------------
# The oracle/database:12.2.0.1-ee image has to exist
#
# HOW TO BUILD THIS IMAGE
# -----------------------
# Put the downloaded patch(es) into the sub folders patch/0NN
# Run: 
#      $ docker build -f Dockerfile.ee -t oracle/database:12.2.0.1-ee-<patch level> . 
#
# Pull base image
# ---------------
FROM oracle/database:12.2.0.1-ee

# Environment variables required for this build (do NOT change)
# -------------------------------------------------------------
ENV PATCH_DIR="patches" \
    PATCH_FILE="applyPatches.sh"

# Use second ENV so that variable get substituted
ENV PATCH_INSTALL_DIR=$ORACLE_BASE/patches

# Copy binaries
# -------------
COPY $PATCH_DIR $PATCH_INSTALL_DIR/

USER root

# Change file ownership
RUN chown -R oracle:dba $PATCH_INSTALL_DIR 

USER oracle

# Install patches