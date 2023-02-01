FROM ubuntu:20.10

RUN apt update && apt install --no-install-recommends -y npm && rm -rf /var/lib/apt/lists/*;

RUN npm i -g @alphahorizonio/unisockets --unsafe-perm && npm cache clean --force;
