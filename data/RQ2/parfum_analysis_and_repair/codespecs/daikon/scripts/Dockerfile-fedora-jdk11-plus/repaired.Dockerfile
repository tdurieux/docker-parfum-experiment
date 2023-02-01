# Create a Docker image that is ready to run the full Daikon tests,
# including building the manual and Javadoc.
# But it's used primarily for running miscellaneous tests such as the manual
# and Javadoc.

FROM fedora:35
MAINTAINER Michael Ernst <mernst@cs.washington.edu>

# According to
# https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/:
#  * Put "apt-get update" and "apt-get install" in the same RUN command.
#  * Do not run "apt-get upgrade"; instead get upstream to update.