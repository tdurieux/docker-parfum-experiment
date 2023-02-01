FROM tensorflow/tensorflow:2.3.1-gpu
# FROM tensorflow/tensorflow:2.4.0rc0-gpu
MAINTAINER moono.song "toilety@gmail.com"
RUN apt-get update -y
RUN apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir pillow

# add sudoer
ARG USERNAME=anonymous
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Create the user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    #
    # [Optional] Add sudo support. Omit if you don't need to install software after connecting.
    && apt-get update \
    && apt-get install --no-install-recommends -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME && rm -rf /var/lib/apt/lists/*;

# ********************************************************
# * Anything else you want to do like clean up goes here *
# ********************************************************

# [Optional] Set the default user. Omit if you want to keep the default as root.
USER $USERNAME

# add port for multiworker training
EXPOSE 12345