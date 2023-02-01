FROM debian:stable

RUN apt-get update -y
RUN apt-get upgrade -y

# env requirements
RUN apt-get install -y python3-pip

# build requirements
RUN apt-get install -y make git
RUN apt-get install -y python3-dev python3-setuptools python3-numpy-dev

# docs requirements
RUN apt-get install -y \
    texlive-fonts-recommended texlive-latex-extra \
    texlive-latex-recommended
RUN pip3 install sphinx git+https://git.pyrocko.org/pyrocko/sphinx-sleekcat-theme.git

# base runtime requirements
RUN apt-get install -y \
        python3-numpy python3-scipy python3-matplotlib \
        python3-requests python3-future \
        python3-yaml python3-progressbar

# gui runtime requirements
RUN apt-get install -y \
        python3-pyqt5 python3-pyqt5.qtopengl python3-pyqt5.qtsvg \
        python3-pyqt5.qtwebengine python3-pyqt5.qtwebkit
