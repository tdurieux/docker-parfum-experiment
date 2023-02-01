FROM tensorflow/tensorflow:2.1.0-py3

COPY install/ubuntu_install_core.sh /install/ubuntu_install_core.sh
RUN bash /install/ubuntu_install_core.sh

RUN pip3 install --no-cache-dir pytest cpplint pylint
RUN pip3 install --no-cache-dir https://download.pytorch.org/whl/cu100/torch-1.3.1%2Bcu100-cp36-cp36m-linux_x86_64.whl

COPY install/ubuntu_install_conda.sh /install/ubuntu_install_conda.sh
RUN bash /install/ubuntu_install_conda.sh cpu
