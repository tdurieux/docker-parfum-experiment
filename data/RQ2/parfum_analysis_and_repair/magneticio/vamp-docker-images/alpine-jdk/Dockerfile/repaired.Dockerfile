# Alpine 3.6 version of java:openjdk-8-jre-alpine
# From: https://github.com/docker-library/openjdk/blob/9a0822673dffd3e5ba66f18a8547aa60faed6d08/8-jre/alpine/Dockerfile

# this is updated for java 9 backported features
FROM alpine:3.6

# A few problems with compiling Java from source:
#  1. Oracle.  Licensing prevents us from redistributing the official JDK.
#  2. Compiling OpenJDK also requires the JDK to be installed, and it gets
#       really hairy.

# Default to UTF-8 file.encoding
ENV LANG C.UTF-8

# add a simple script that can auto-detect the appropriate JAVA_HOME value
# based on whether the JDK or only the JRE is installed