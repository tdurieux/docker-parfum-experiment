FROM gitpod/workspace-full

# Taken from https://github.com/meteor/todos/pull/275/files
USER gitpod
RUN cd /home/gitpod && curl -f https://install.meteor.com/ | sh