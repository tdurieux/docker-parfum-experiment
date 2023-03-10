FROM ubuntu:18.04
# The ARG should be ignored due to the
# conflict with the ENV declaration.
ARG USER_NAME=my_user_arg
ENV USER_NAME=my_user_env
RUN useradd -r -s /bin/false -m -d /home/${USER_NAME} ${USER_NAME}
USER ${USER_NAME}
WORKDIR /home/${USER_NAME}