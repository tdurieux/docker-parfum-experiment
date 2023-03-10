ARG BASE_IMAGE=starwhaleai/base:latest
FROM ${BASE_IMAGE}

# docker in docker
RUN curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --batch --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
    && curl -f -s -L "https://nvidia.github.io/libnvidia-container/$(. /etc/os-release;echo $ID$VERSION_ID)/libnvidia-container.list" | \
       sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
       sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list \
    && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - \
    && apt-key fingerprint 0EBFCD88 \
    && add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
    && apt-get update \
    && apt-get install --no-install-recommends -y docker-ce=5:20.10.14~3-0~ubuntu-focal docker-ce-cli=5:20.10.14~3-0~ubuntu-focal nvidia-docker2 && rm -rf /var/lib/apt/lists/*;

VOLUME /var/lib/docker

COPY external/dind-dockerd-entrypoint.sh /usr/local/bin/
COPY external/docker_daemon.json /etc/docker/daemon.json

# cuda runtime
ENV NVARCH x86_64
ENV NVIDIA_REQUIRE_CUDA "cuda>=11.4 brand=tesla,driver>=418,driver<419 brand=tesla,driver>=440,driver<441 brand=tesla,driver>=450,driver<451 brand=tesla,driver>=460,driver<461"
ENV NV_CUDA_CUDART_VERSION 11.4.43-1
ENV NV_CUDA_COMPAT_PACKAGE cuda-compat-11-4
ENV CUDA_VERSION 11.4.0

ENV NV_ML_REPO_ENABLED 1
ENV NV_ML_REPO_URL https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu2004/${NVARCH}

RUN apt install -y --no-install-recommends dirmngr \
    && wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-keyring_1.0-1_all.deb \
    && dpkg -i cuda-keyring_1.0-1_all.deb \
    && apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/3bf863cc.pub \
    && apt-get update \
    && apt-get install -y --no-install-recommends cuda-cudart-11-4=${NV_CUDA_CUDART_VERSION} ${NV_CUDA_COMPAT_PACKAGE} \
    && ln -s cuda-11.4 /usr/local/cuda \
    && apt-get clean all \
    && rm cuda-keyring_1.0-1_all.deb \
    && rm -rf /var/lib/apt/lists/* /tmp/*

ENV PATH /usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility

ENTRYPOINT ["dind-dockerd-entrypoint.sh"]