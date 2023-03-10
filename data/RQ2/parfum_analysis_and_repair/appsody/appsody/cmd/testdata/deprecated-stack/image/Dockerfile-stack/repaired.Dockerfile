# Dockerfile for building the stack

FROM registry.access.redhat.com/ubi7/ubi

# See https://appsody.dev/docs/stacks/environment-variables for more information about each variable.

# Mount the application directory into the container filesystem, for example
ENV APPSODY_MOUNTS=/:/project/userapp

# Define a volume for dependencies to be stored between runs, for example
ENV APPSODY_DEPS=/project/deps

# Directories to watch for changes in
ENV APPSODY_WATCH_DIR=/project/userapp

# Directories to ignore changes in
ENV APPSODY_WATCH_IGNORE_DIR= 

# Types of file that will trigger a re-launch (change this to be specific to your application).
ENV APPSODY_WATCH_REGEX="^.*.sh$"

# Optional command executed before RUN/TEST/DEBUG - typically used to install any dependencies from
# the user application
ENV APPSODY_PREP=

# Configurations for appsody run
# APPSODY_RUN should specify the command to launch your application
# APPSODY_RUN_ON_CHANGE should specify the command to re-launch your application if triggered by a file change
# APPSODY_RUN_KILL Signals whether to kill the server process before starting the APPSODY_RUN_ON_CHANGE action

ENV APPSODY_RUN="/bin/bash /project/userapp/hello.sh"
ENV APPSODY_RUN_ON_CHANGE=$APPSODY_RUN
ENV APPSODY_RUN_KILL=false

# Configurations for appsody debug
# APPSODY_DEBUG should specify the command to launch your application in debug mode
# APPSODY_DEBUG_ON_CHANGE should specify the command to re-launch your application in debug mode if triggered by a file change
# APPSODY_DEBUG_KILL Signals whether to kill the server process before starting the APPSODY_DEBUG_ON_CHANGE action

ENV APPSODY_DEBUG="echo -n \"Debugging \"; /bin/bash /project/userapp/hello.sh"
ENV APPSODY_DEBUG_ON_CHANGE=$APPSODY_DEBUG
ENV APPSODY_DEBUG_KILL=false

# Configurations for appsody test
# APPSODY_TEST should specify the command to launch your application in test mode
# APPSODY_TEST_ON_CHANGE should specify the command to re-launch your application in test mode if triggered by a file change
# APPSODY_TEST_KILL Signals whether to kill the server process before starting the APPSODY_TEST_ON_CHANGE action

ENV APPSODY_TEST="/bin/bash /project/userapp/tests/test.sh"
ENV APPSODY_TEST_ON_CHANGE=$APPSODY_TEST
ENV APPSODY_TEST_KILL=false

# Copy the common components across into your stack filesystem (most stacks will need these)
COPY ./LICENSE /licenses/
COPY ./project /project
COPY ./config /config

# Set the working directory to the project directory, which typically contains the stack components and userapp
WORKDIR /project

# Expose the relevant ports (change this to be specific to your application).