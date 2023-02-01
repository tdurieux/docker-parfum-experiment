# Dockerfile to build this thing
# Usage:
#   docker build -t sqflint_builder .
#   docker run -e "GITHUB_WORKSPACE=/opt/build" -v ./:/opt/build sqflint_builder
# Artifacts will be stored in dist
FROM openjdk:8

# Installs Ant