FROM ubuntu:20.04

LABEL maintainer="maho.nakata@gmail.com"

ARG DEBIAN_FRONTEND=noninteractive
RUN apt -y update
RUN apt -y upgrade
RUN apt install --no-install-recommends -y sudo && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y tzdata && rm -rf /var/lib/apt/lists/*;
# set your timezone
ENV TZ Asia/Tokyo
RUN echo "${TZ}" > /etc/timezone \
  && rm /etc/localtime \
  && ln -s /usr/share/zoneinfo/Asia/Tokyo /etc/localtime \
  && dpkg-reconfigure -f noninteractive tzdata

RUN apt install --no-install-recommends -y build-essential python3 gcc g++ gfortran && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y gcc-10 g++-10 gfortran-10 && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y autotools-dev automake libtool && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y gdb valgrind libtool-bin && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y git wget ccache time pkg-config clangd clang-format unifdef octave && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y ng-common ng-cjk emacs-nox && rm -rf /var/lib/apt/lists/*;
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 1

### intel one api start ###
RUN wget https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB
RUN apt-key add GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB
RUN echo "deb https://apt.repos.intel.com/oneapi all main" | sudo tee /etc/apt/sources.list.d/oneAPI.list
RUN apt update
RUN apt install --no-install-recommends -y intel-basekit && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y intel-hpckit && rm -rf /var/lib/apt/lists/*;
### intel one api end ###

### mingw start ###
RUN apt install --no-install-recommends -y mingw-w64 gfortran-mingw-w64 gdb-mingw-w64 && rm -rf /var/lib/apt/lists/*;
RUN dpkg --add-architecture i386
RUN wget -nc https://dl.winehq.org/wine-builds/winehq.key
RUN mv winehq.key /usr/share/keyrings/winehq-archive.key
RUN wget -nc https://dl.winehq.org/wine-builds/ubuntu/dists/focal/winehq-focal.sources
RUN mv winehq-focal.sources /etc/apt/sources.list.d/
RUN apt update -y
RUN apt install -y --install-recommends winehq-stable
### mingw end ###

ARG DOCKER_UID=1000
ARG DOCKER_USER=docker
ARG DOCKER_PASSWORD=docker
RUN useradd -u $DOCKER_UID -m $DOCKER_USER --shell /bin/bash && echo "$DOCKER_USER:$DOCKER_PASSWORD" | chpasswd && echo "$DOCKER_USER ALL=(ALL) ALL" >> /etc/sudoers
ARG WORK=/home/$DOCKER_USER

#install ctag
RUN cd ${WORK} && git clone https://github.com/universal-ctags/ctags.git
RUN cd ${WORK} && cd ctags && ./autogen.sh && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr/local && make && make install

USER docker    
USER ${DOCKER_USER}
ARG GIT_EMAIL="maho.nakata@gmail.com"
ARG GIT_NAME="NAKATA Maho"
RUN echo "\n\
[user]\n\
        email = ${GIT_EMAIL}\n\
        name = ${GIT_NAME}\n\
" > /home/$DOCKER_USER/.gitconfig
SHELL ["/bin/bash", "-c"]
RUN cd ${WORK} && wget https://raw.githubusercontent.com/cctbx/cctbx_project/master/libtbx/auto_build/bootstrap.py --no-check-certificate
RUN cd ${WORK} && python bootstrap.py hot update --builder=cctbx
RUN cd ${WORK} && wget https://repo.anaconda.com/miniconda/Miniconda2-4.5.11-Linux-x86_64.sh
RUN cd ${WORK} && bash ./Miniconda2-4.5.11-Linux-x86_64.sh -b -p

RUN cd ${WORK} && source miniconda2/etc/profile.d/conda.sh && conda create -y --name fable38 python=3.8 && conda activate fable38 && conda install six future && mkdir build38 && cd ${WORK}/build38 && python ../modules/cctbx_project/libtbx/configure.py fable
RUN source ${WORK}/build38/setpaths.sh && cd ${WORK}/build38 && make && cd ${WORK} && cd ${WORK}/build38 && make ; cd ${WORK}
RUN cd ${WORK} && echo "source /home/docker/miniconda2/etc/profile.d/conda.sh" >> .bashrc
RUN cd ${WORK} && echo "conda activate fable38" >> .bashrc
RUN cd ${WORK} && echo "source /home/docker/build38/setpaths.sh" >> .bashrc
RUN echo -e "\n\
        PROGRAM HELLO\n\
        PRINT *, 'HELLO, WORLD!'\n\
        END PROGRAM\n\
" >> ${WORK}/sample.f

#setting lsp mode for C++ https://emacs-lsp.github.io/lsp-mode/tutorials/CPP-guide/
RUN cd ${WORK} && mkdir -p .emacs.d
RUN echo -e "\n\
[user]\n\
        email = ${GIT_EMAIL}\n\
        name = ${GIT_NAME}\n\
" >> /home/$DOCKER_USER/.gitconfig

RUN echo -e "(require 'package)\n\
(add-to-list 'package-archives '(\"melpa\" . \"http://melpa.org/packages/\") t)\n\
(package-initialize)\n\
\n\
(setq package-selected-packages '(lsp-mode yasnippet lsp-treemacs helm-lsp\n\
    projectile hydra flycheck company avy which-key helm-xref dap-mode))\n\
\n\
(when (cl-find-if-not #'package-installed-p package-selected-packages)\n\
  (package-refresh-contents)\n\
  (mapc #'package-install package-selected-packages))\n\
\n\
;; sample 'helm' configuration use https://github.com/emacs-helm/helm/ for details\n\
(helm-mode)\n\
(require 'helm-xref)\n\
(define-key global-map [remap find-file] #'helm-find-files)\n\
(define-key global-map [remap execute-extended-command] #'helm-M-x)\n\
(define-key global-map [remap switch-to-buffer] #'helm-mini)\n\
\n\
(which-key-mode)\n\
(add-hook 'c-mode-hook 'lsp)\n\
(add-hook 'c++-mode-hook 'lsp)\n\
\n\
(setq gc-cons-threshold (* 100 1024 1024)\n\
      read-process-output-max (* 1024 1024)\n\
      treemacs-space-between-root-nodes nil\n\
      company-idle-delay 0.0\n\
      company-minimum-prefix-length 1\n\
      lsp-idle-delay 0.1)  ;; clangd is fast\n\
\n\
(with-eval-after-load 'lsp-mode\n\
  (add-hook 'lsp-mode-hook #'lsp-enable-which-key-integration)\n\
  (require 'dap-cpptools)\n\
  (yas-global-mode))\n\
" >> ${WORK}/.emacs.d/init.el

RUN cd ${WORK} && echo "cd /home/$DOCKER_USER" >> .bashrc
RUN cd ${WORK} && echo 'eval "$(ssh-agent -s)"' >> .bashrc
RUN cd ${WORK} && echo 'ssh-add ~/.ssh/id_ed25519' >> .bashrc

## intel one api and wine settings start ###
RUN cd ${WORK} && echo "#source /opt/intel/oneapi/setvars.sh" >> .bashrc
RUN cd ${WORK} && echo "export WINEPATH=\"/usr/x86_64-w64-mingw32/lib/;/usr/lib/gcc/x86_64-w64-mingw32/9.3-win32/;/usr/lib/gcc/x86_64-w64-mingw32/9.3-posix;/home/$DOCKER_USER/MPLAPACK_MINGW/bin\"" >> .bashrc
RUN cd ${WORK} && echo "export WINEDEBUG=\"-all\"" >> .bashrc
## intel one api and wine settings end ###

RUN cd ${WORK} && git clone https://github.com/nakatamaho/mplapack.git
RUN cd ${WORK}/mplapack && git fetch origin v2.0
RUN cd ${WORK}/mplapack && git checkout v2.0
RUN cd ${WORK}/mplapack && git remote set-url origin git@github.com:nakatamaho/mplapack.git
RUN cd ${WORK}/mplapack && git log -1
RUN cd ${WORK}/mplapack && bash -x misc/reconfig.develop.sh
RUN cd ${WORK}/mplapack && make -j`getconf _NPROCESSORS_ONLN`
