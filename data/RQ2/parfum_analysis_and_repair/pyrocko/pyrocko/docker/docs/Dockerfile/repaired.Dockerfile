FROM debian:stable

RUN apt-get update -y
RUN apt-get upgrade -y

# env requirements
RUN apt-get install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;

# build requirements
RUN apt-get install --no-install-recommends -y make git && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3-dev python3-setuptools python3-numpy-dev && rm -rf /var/lib/apt/lists/*;

# docs requirements
RUN apt-get install --no-install-recommends -y \
    texlive-fonts-recommended texlive-latex-extra \
    texlive-latex-recommended && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir sphinx git+https://git.pyrocko.org/pyrocko/sphinx-sleekcat-theme.git

# base runtime requirements
RUN apt-get install --no-install-recommends -y \
        python3-numpy python3-scipy python3-matplotlib \
        python3-requests python3-future \
        python3-yaml python3-progressbar && rm -rf /var/lib/apt/lists/*;

# gui runtime requirements
RUN apt-get install --no-install-recommends -y \
        python3-pyqt5 python3-pyqt5.qtopengl python3-pyqt5.qtsvg \
        python3-pyqt5.qtwebengine python3-pyqt5.qtwebkit && rm -rf /var/lib/apt/lists/*;
