FROM apulistech/algorithm-segmentation:1.8
MAINTAINER Jin Li <jinlmsft@hotmail.com>

# Add sudo
RUN apt-get -y --no-install-recommends install sudo && rm -rf /var/lib/apt/lists/*;

# Add user ubuntu with no password, add to sudo group
RUN adduser --disabled-password --gecos '' ubuntu
RUN adduser ubuntu sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER ubuntu
WORKDIR /home/ubuntu/
RUN chmod a+rwx /home/ubuntu/

# Anaconda installing
RUN wget https://repo.continuum.io/archive/Anaconda3-5.0.1-Linux-x86_64.sh
RUN bash Anaconda3-5.0.1-Linux-x86_64.sh -b
RUN rm Anaconda3-5.0.1-Linux-x86_64.sh

# Set path to conda
#ENV PATH /root/anaconda3/bin:$PATH
ENV PATH /home/ubuntu/anaconda3/bin:$PATH

# Updating Anaconda packages
RUN conda update conda
RUN conda update anaconda
RUN conda update --all

RUN conda create -n open-mmlab python=3.7 -y
RUN conda activate open-mmlab

RUN git clone https://github.com/open-mmlab/mmdetection.git
WORKDIR /home/ubuntu/mmdetection
RUN python setup.py develop