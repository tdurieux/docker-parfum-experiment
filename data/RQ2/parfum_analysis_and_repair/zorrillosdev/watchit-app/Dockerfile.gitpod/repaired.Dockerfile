FROM gitpod/workspace-full-vnc

RUN sudo apt-get update && sudo apt-get install --no-install-recommends -y libgtkextra-dev libgconf2-dev libnss3 libasound2 libxtst-dev libgbm-dev && rm -rf /var/lib/apt/lists/*;
