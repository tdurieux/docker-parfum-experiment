FROM library/archlinux:latest
LABEL author="ehasanaj@cs.cmu.edu"

RUN pacman -Syyu --noconfirm

RUN pacman -S --noconfirm\
        base-devel\
        git\
        vim\
        wget && pacman -Scc --noconfirm

RUN useradd -m nonroot
RUN echo "nonroot ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/nonroot
USER nonroot

# Install Miniconda
RUN mkdir /home/nonroot/downloads
RUN git clone https://aur.archlinux.org/miniconda3.git /home/nonroot/downloads/miniconda3
RUN cd /home/nonroot/downloads/miniconda3 && makepkg -scri --noconfirm
RUN echo "[ -f /opt/miniconda3/etc/profile.d/conda.sh ] && source /opt/miniconda3/etc/profile.d/conda.sh" >> ~/.bashrc && source ~/.bashrc

RUN wget -P /home/nonroot/downloads/ https://raw.githubusercontent.com/euxhenh/cellar/main/installer.sh && \
        wget -P /home/nonroot/downloads/ https://raw.githubusercontent.com/euxhenh/cellar/main/install_Rdeps.py

# Create conda environment and perform clean ups
ENV PATH /opt/miniconda3/bin:$PATH
RUN conda create -n cellar python=3.8 && \
        cd /home/nonroot/downloads && \
        conda run --no-capture-output -n cellar bash installer.sh && \
        conda run --no-capture-output -n cellar python install_Rdeps.py && \
        conda clean -afy && \
        rm -rf /home/nonroot/downloads && \
        rm -rf /home/nonroot/.conda/pkgs/*