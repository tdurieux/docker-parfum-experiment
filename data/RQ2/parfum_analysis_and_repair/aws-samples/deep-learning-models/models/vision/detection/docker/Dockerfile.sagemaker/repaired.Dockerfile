FROM 763104351884.dkr.ecr.us-east-1.amazonaws.com/tensorflow-training:2.2.0-gpu-py37-cu102-ubuntu18.04

ARG SMDEBUG_VERSION=0.8.1

RUN pip uninstall -y numpy

RUN pip install --no-cache-dir tensorflow_addons \
                s3fs \
                ipykernel \
                imgaug \
                tqdm \
                tensorflow_datasets \
                scikit-image \
                cython \
                addict \
                terminaltables \
                opencv-python==4.2.0.32 \
                sagemaker==1.58.2 \
                sagemaker-experiments==0.1.13 \
                "sagemaker-tensorflow>=2.2,<2.3" \
                sagemaker-tensorflow-training==4.0.1 \
                werkzeug==1.0.1 \
                smdebug==${SMDEBUG_VERSION} \
                numba && \
    pip install --no-cache-dir numpy==1.17.5 pycocotools

#########################################################
# Fix ssh for container communication
#########################################################

# SSH login fix. Otherwise user is kicked off after login
RUN mkdir -p /var/run/sshd \
 && sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

# Create SSH key.
RUN mkdir -p /root/.ssh/ \
 && cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys \
 && printf "Host *\n  StrictHostKeyChecking no\n" >> /root/.ssh/config

# Allow OpenSSH to talk to containers without asking for confirmation
RUN cat /etc/ssh/ssh_config | grep -v StrictHostKeyChecking > /etc/ssh/ssh_config.new \
 && echo "    StrictHostKeyChecking no" >> /etc/ssh/ssh_config.new \
 && mv /etc/ssh/ssh_config.new /etc/ssh/ssh_config

WORKDIR /

###########################################################################
# 7. Setup deep learning container utilities for Sagemaker
###########################################################################

ADD https://raw.githubusercontent.com/aws/aws-deep-learning-containers-utils/master/deep_learning_container.py \
 /usr/local/bin/deep_learning_container.py

RUN chmod +x /usr/local/bin/deep_learning_container.py

RUN curl -f https://aws-dlc-licenses.s3.amazonaws.com/tensorflow-2.1/license.txt -o /license.txt

##########################################
# Additional components for notebook use
##########################################

# Nodejs for jupyter lab extensions

RUN apt-get update
RUN apt-get install --no-install-recommends -y xvfb && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3-opengl && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y ffmpeg && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://deb.nodesource.com/setup_13.x | bash -
RUN apt-get -y --no-install-recommends install nodejs && rm -rf /var/lib/apt/lists/*;
RUN npm install && npm cache clean --force;

RUN pip install --no-cache-dir tornado

RUN pip install --no-cache-dir jupyter \
                jupyterlab==1.2.0 \
                tensorflow_addons \
                ipywidgets \
                matplotlib \
                seaborn

RUN pip install --no-cache-dir jupyterlab-nvdashboard \
                jupyter-tensorboard && \
    jupyter labextension install @jupyter-widgets/jupyterlab-manager \
                                 jupyterlab-nvdashboard jupyterlab_tensorboard

RUN mkdir /workspace
WORKDIR /workspace

RUN apt-get install --no-install-recommends -y zsh && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y powerline fonts-powerline && rm -rf /var/lib/apt/lists/*;
RUN git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
RUN cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc

RUN ln -s /usr/local/cuda-10.2/targets/x86_64-linux/lib/libcudart.so.10.2 /usr/lib/x86_64-linux-gnu/libcudart.so.10.1

ENV SHELL=/bin/zsh
CMD nohup xvfb-run -s "-screen 0 1400x900x24" jupyter lab --allow-root --ip=0.0.0.0 --no-browser > notebook.log

