ARG BASE_IMAGE=ghcr.io/nakkaya/emacsd-cpu
FROM $BASE_IMAGE as build

ENV USER="core" \
    UID=1000 \
    TZ=UTC

USER root

# Install Packages
#
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install curl -y --no-install-recommends && \
    curl -f -sL https://deb.nodesource.com/setup_16.x | sudo -E bash - && rm -rf /var/lib/apt/lists/*;

RUN apt-get install \

    gnupg software-properties-common \

    openssh-server sudo iputils-ping bash-completion \
    unzip wget htop xz-utils nq \
    graphviz postgresql-client python3-psycopg2 qutebrowser \
    offlineimap dovecot-imapd dnsutils nano iproute2 \
    direnv \

    rsync rclone git git-annex git-annex-remote-rclone \
    apt-transport-https apache2-utils \

    openjdk-11-jdk maven \

    build-essential gcc-10 g++-10 clang clangd cmake cppcheck valgrind \

    texlive-latex-base texlive-xetex texlive-lang-english \
    texlive-lang-european texlive-plain-generic texlive-fonts-recommended \
    pandoc latexmk \

    libpng-dev zlib1g-dev libpoppler-glib-dev \
    libpoppler-private-dev imagemagick \

    libgl1 libglib2.0-0 \

    autoconf automake libtool \


    -y --no-install-recommends && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends ispell -y && rm -rf /var/lib/apt/lists/*;

# Node
#
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

# Install Terraform
#
RUN ARCH="$(dpkg --print-architecture)"; \
    TERRAFORM_VERSION=0.14.11; \
    TERRAFORM_LS_VERSION=0.22.0; \
    TERRAFORM_DIST="terraform_${TERRAFORM_VERSION}_linux_${ARCH}.zip"; \
    TERRAFORM_LS_DIST="terraform-ls_${TERRAFORM_LS_VERSION}_linux_${ARCH}.zip"; \
    echo $TERRAFORM_DIST && \
    echo $TERRAFORM_LS_DIST && \
    wget -q https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/${TERRAFORM_DIST} && \
    wget -q https://releases.hashicorp.com/terraform-ls/${TERRAFORM_LS_VERSION}/${TERRAFORM_LS_DIST} && \
    unzip ${TERRAFORM_DIST} -d /usr/bin && \
    rm -rf ${TERRAFORM_DIST} && \
    unzip ${TERRAFORM_LS_DIST} -d /usr/bin && \
    rm -rf ${TERRAFORM_LS_DIST}

# Install Docker CLI
#
RUN ARCH="$(dpkg --print-architecture)"; \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
    gpg --batch --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
    echo \
    "deb [arch=${ARCH} signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && \
    apt-get install docker-ce-cli -y --no-install-recommends && \
    pip install --no-cache-dir docker-compose && \
    touch /var/run/docker.sock && \
    groupadd docker && \
    chown root:docker /var/run/docker.sock && \
    usermod -a -G docker $USER && rm -rf /var/lib/apt/lists/*;

# Install Syncthing
#
RUN wget -q https://syncthing.net/release-key.txt -O- | apt-key add - && \
    add-apt-repository "deb https://apt.syncthing.net/ syncthing stable" && \
    apt-get update && \
    apt-get install syncthing -y --no-install-recommends && rm -rf /var/lib/apt/lists/*;

# Configure Python
#

RUN pip install --no-cache-dir \
    markupsafe==2.0.1 \
    invoke \
    ansible \
    ansible-lint \
    jupyterlab \
    mlflow \
    python-lsp-server[all] \
    ical2orgpy

RUN ARCH="$(dpkg --print-architecture)"; \
    case "$ARCH" in \
            amd64 pip install --no-cache-dir tensorflow-gpu tensorflow-datasets torch torchvision gym segmentation-models albumentations;; \
          esac;

RUN pip install --no-cache-dir \

    numpy \
    numexpr \
    pandas \
    scipy \
    scikit-learn \
    scikit-image \
    pillow \
    opencv-python \
    boto3 \
    nibabel \
    pydicom \

    pandas_ta \
    yfinance \
    python-binance \
    py3cw \

    matplotlib \
    plotly \

    pygments \
    nbstripout \
    click

RUN pip install --no-cache-dir numpy --upgrade && \
    pip install --no-cache-dir jinja2 --upgrade

# Install Jupyter
#

COPY resources/jupyter/themes.jupyterlab-settings /home/$USER/.jupyter/lab/user-settings/@jupyterlab/apputils-extension/themes.jupyterlab-settings
COPY resources/jupyter/shortcuts.jupyterlab-settings /home/$USER/.jupyter/lab/user-settings/@jupyterlab/shortcuts-extension/shortcuts.jupyterlab-settings
COPY resources/jupyter/tracker.jupyterlab-settings /home/$USER/.jupyter/lab/user-settings/@jupyterlab/notebook-extension/tracker.jupyterlab-settings
COPY resources/jupyter/terminal-plugin.jupyterlab-settings /home/$USER/.jupyter/lab/user-settings/@jupyterlab/terminal-extension/plugin.jupyterlab-settings
COPY resources/jupyter/extension-plugin.jupyterlab-settings /home/$USER/.jupyter/lab/user-settings/@jupyterlab/extensionmanager-extension/plugin.jupyterlab-settings

# Install Clojure
#
RUN wget https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein -P /usr/bin/ && \
    chmod 755 /usr/bin/lein && \
    /bin/bash -c "$(curl -fsSL https://download.clojure.org/install/linux-install-1.11.1.1113.sh)" && \
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/clojure-lsp/clojure-lsp/master/install)" && \
    /bin/bash -c "$( curl -f -s https://raw.githubusercontent.com/babashka/babashka/master/install)" -f

# Install AWS CLI
#
RUN ARCH="$(dpkg --print-architecture)"; \
    case "$ARCH" in \
            amd64) URL='https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip' ;; \
            arm64) URL='https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip' ;; \
    esac; \
    cd /opt/ && \
    curl -f -s "${URL}" -o "awscliv2.zip" && \
    unzip -q awscliv2.zip && \
    ./aws/install && \
    rm awscliv2.zip

# Install Google Cloud CLI
#
RUN ARCH="$(dpkg --print-architecture)"; \
    curl -f https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add - && \
    echo \
    "deb [arch=${ARCH} signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt \
    cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    apt-get update && \
    apt-get install google-cloud-sdk -y --no-install-recommends && rm -rf /var/lib/apt/lists/*;


# Arduino
#
# RUN wget http://downloads.arduino.cc/arduino-1.8.13-linux64.tar.xz && \
#     tar xf arduino-1.8.13-linux64.tar.xz && \
#     mv arduino-1.8.13 /usr/local/share/arduino && \
#     ln -s /usr/local/share/arduino/arduino /usr/local/bin/arduino && \
#     ln -s /usr/local/share/arduino/arduino-builder /usr/local/bin/arduino-builder && \
#     rm -rf arduino-1.8.13-linux64.tar.xz && \
#     arduino --install-boards arduino:sam && \
#     wget https://www.pjrc.com/teensy/td_153/TeensyduinoInstall.linux64 && \
#     chmod +x TeensyduinoInstall.linux64 && \
#     ./TeensyduinoInstall.linux64  --dir=/usr/local/share/arduino && \
#     rm -rf TeensyduinoInstall.linux64

RUN apt-get autoremove -y && \
    apt-get clean && \
    apt-get autoclean

# Setup Emacs
#
RUN git clone https://github.com/nakkaya/emacs /opt/emacsd/conf && \
    echo "(setq package-native-compile t)" > /home/$USER/.emacs && \
    echo "(load-file \"/opt/emacsd/conf/init.el\")" >> /home/$USER/.emacs

COPY resources/bin/ob-tangle.sh /usr/bin/ob-tangle
RUN sudo chmod +x /usr/bin/ob-tangle
COPY resources/bin/bootrc /home/$USER/.bootrc

RUN mkdir -p /home/$USER/.local/share/ && \
    chown -R $USER:$USER /opt/emacsd && \
    chown -R $USER:$USER /home/$USER && \
    chown -R $USER:$USER /storage

USER $USER

RUN echo ' ' >> /home/$USER/.bashrc && \
    echo 'export PYTHONDONTWRITEBYTECODE=1' >> /home/$USER/.bashrc && \
    echo 'export TF_CPP_MIN_LOG_LEVEL=2' >> /home/$USER/.bashrc && \
    echo 'export GIT_PYTHON_REFRESH=quiet' >> /home/$USER/.bashrc

FROM scratch
COPY --from=build / /

ENV USER="core"
USER $USER
WORKDIR /storage
CMD /opt/emacsd/exec.sh
