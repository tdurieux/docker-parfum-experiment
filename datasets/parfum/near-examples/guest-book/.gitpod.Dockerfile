FROM gitpod/workspace-full

RUN bash -c ". .nvm/nvm.sh \
             && nvm install v14 && nvm alias default v14"
