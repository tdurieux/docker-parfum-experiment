FROM nvidia/cuda:11.6.0-devel-ubuntu20.04

RUN echo "" && \
    echo "-================================================================-" && \
    echo "-================================================================-" && \
    echo "" && \
    echo "This dockerfile is GPU only, and needs you to nominate the GPUs to" && \
    echo "run.  The common form is 'docker build . -t progrockdiffusion' and" && \
    echo "'docker run progrockdiffusion --gpus all'" && \
    echo "" && \
    echo "-================================================================-" && \
    echo "-================================================================-" && \
    echo "" && \
    echo "Updating the base" && \
    apt update && \
    apt update && \
    apt upgrade -y && \
    apt install --no-install-recommends git -y && \
    apt install --no-install-recommends nano -y && \
    apt install --no-install-recommends curl -y && \
    apt install --no-install-recommends wget -y && rm -rf /var/lib/apt/lists/*;

# disable text prompts regarding timezone during python installation
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends tzdata && rm -rf /var/lib/apt/lists/*;

RUN echo "Updating apt-get, installing OS basics" && \
    apt-get -y update && \
    apt-get install --no-install-recommends -y software-properties-common && \
    apt-get -y update && \
    add-apt-repository universe && rm -rf /var/lib/apt/lists/*;

RUN echo "!! Installing python 3 and pip" && \
    apt-get -y --no-install-recommends install python3 && \
    apt-get -y --no-install-recommends install python3-pip && rm -rf /var/lib/apt/lists/*;

RUN echo "!! Pulling the various repos" && \
    git clone https://github.com/lowfuel/progrockdiffusion.git && \
    cd progrockdiffusion && \
    git clone https://github.com/crowsonkb/guided-diffusion && \
    git clone https://github.com/openai/CLIP.git && \
    git clone https://github.com/assafshocher/ResizeRight.git

RUN echo "!! pip installing the repos" && \
    cd progrockdiffusion && \
    pip -V && \
    pip install --no-cache-dir opencv-python && \
    pip install --no-cache-dir -e ./CLIP && \
    pip install --no-cache-dir -e ./guided-diffusion && \
    pip install --no-cache-dir lpips datetime timm

RUN echo "!! install torch, torchvision, torchaudio, imagemagic, ffmpeg, misc" && \
    pip install --no-cache-dir torch==1.10.2+cu113 -f https://download.pytorch.org/whl/cu113/torch_stable.html --no-cache && \
    pip install --no-cache-dir torchvision==0.11.3+cu113 -f https://download.pytorch.org/whl/cu113/torch_stable.html && \
    pip install --no-cache-dir torchaudio==0.10.2+cu113 -f https://download.pytorch.org/whl/cu113/torch_stable.html && \
    apt-get install --no-install-recommends ffmpeg libsm6 libxext6 -y && \
    apt install --no-install-recommends imagemagick caca-utils -y && \
    pip install --no-cache-dir ipywidgets omegaconf pytorch_lightning einops && \
    pip install --no-cache-dir matplotlib pandas && \
    pip install --no-cache-dir json5 numexpr && rm -rf /var/lib/apt/lists/*;

RUN echo "!! Run a single fake frame to get the default model downloaded and baked into the image" && \
    cd progrockdiffusion && \
    python3 prd.py -s settings/validate.json

# CMD /bin/bash
