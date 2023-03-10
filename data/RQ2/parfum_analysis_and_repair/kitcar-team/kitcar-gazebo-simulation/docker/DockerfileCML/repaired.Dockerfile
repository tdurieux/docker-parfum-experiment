ARG PARENT
FROM ${PARENT}

# Install PyTorch with CUDA packages
RUN pip3 install \
    --no-cache-dir \
    --upgrade \
    --upgrade-strategy eager \
    --no-warn-script-location \
    -r /requirements_pytorch_cuda.txt

# Install CML Bot
RUN curl -f -sL https://deb.nodesource.com/setup_12.x | bash && \
    apt-get update && \
    apt-get install --no-install-recommends nodejs -y && \
    sudo npm i -g --unsafe-perm @dvcorg/cml && \
    rm -rf /var/lib/apt/lists/* && npm cache clean --force;
