ARG BASE_IMAGE=openfl:latest
FROM ${BASE_IMAGE}

# Create unprivileged user to limit changes to mounted volumes
ENV username=user
ARG USER_ID=10001
ARG GROUP_ID=1001
RUN addgroup --gid $GROUP_ID $username
RUN adduser --disabled-password --gecos '' --uid $USER_ID --gid $GROUP_ID $username

WORKDIR /home/user
# Allow user to work in home dir
RUN chmod -R a+rw .
# Allow pip to work with existing packages (?)
RUN chmod -R a+rwx /usr/local
USER user

ARG WORKSPACE_NAME
COPY ${WORKSPACE_NAME}.zip .

RUN fx workspace import --archive ${WORKSPACE_NAME}.zip
# Unifying the workspace folder name
RUN mv ${WORKSPACE_NAME} workspace
WORKDIR /home/user/workspace
RUN pip install --no-cache-dir -r requirements.txt
