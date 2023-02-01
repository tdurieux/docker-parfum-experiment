FROM node:14-bullseye-slim

RUN apt update && apt install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;


ARG USER_UID=1000
ARG USER_GID=1000
RUN if [ "$USER_GID" != "1000" ] || [ "$USER_UID" != "1000" ]; then groupmod --gid $USER_GID node && usermod --uid $USER_UID --gid $USER_GID node; fi
