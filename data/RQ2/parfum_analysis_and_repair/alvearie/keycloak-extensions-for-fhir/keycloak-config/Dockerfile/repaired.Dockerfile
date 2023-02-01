# ----------------------------------------------------------------------------
# (C) Copyright IBM Corp. 2021
#
# SPDX-License-Identifier: Apache-2.0
# ----------------------------------------------------------------------------

# Note: this Dockerfile must be executed from the root of the project
# Example:
#   > docker build . -f keycloak-config/Dockerfile

# Build stage
FROM maven:3-jdk-11-slim AS build
COPY pom.xml ./
COPY keycloak-config ./keycloak-config

RUN mvn -B clean package -f keycloak-config -DskipTests


# Package stage