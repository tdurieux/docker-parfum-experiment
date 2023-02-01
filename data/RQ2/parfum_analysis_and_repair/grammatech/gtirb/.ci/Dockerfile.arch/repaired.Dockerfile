FROM archlinux/base

SHELL ["/bin/bash", "-c"]

RUN sed -i 's/#\[multilib\]/\[multilib\]/; /^\[multilib\]/,/^$/ s/^#//' /etc/pacman.conf
RUN pacman --noconfirm -Syu archlinux-keyring
RUN pacman --noconfirm -Syu autoconf base-devel boost capstone clang cmake curl \
        doxygen gcc gcc-libs git graphviz jdk8-openjdk libtool make protobuf \
        python python-networkx python-pip wget
RUN python3 -m pip install pre-commit wheel

# Common-Lisp specific setup.
RUN sed -i "s/^\(OPT_LONG=(\)/\1'asroot' /;s/EUID == 0/1 == 0/" /usr/bin/makepkg
RUN git clone --depth 1 https://aur.archlinux.org/yay.git /yay-aur
RUN sed -i "s|^  cd \"\$srcdir/\$pkgname-\$pkgver\"|&\\n  sed -i 's/os.Geteuid()/1/' main.go install.go|" /yay-aur/PKGBUILD
RUN sed -i "s/package() {/package() {\n  unset LDFLAGS/" /yay-aur/PKGBUILD
RUN cd /yay-aur && makepkg --noconfirm -si
RUN yay --noconfirm -Sy emacs-nox sbcl slime emacs-paredit cl-protobuf
RUN curl -f -O https://beta.quicklisp.org/quicklisp.lisp
RUN sbcl --load quicklisp.lisp \
        --eval '(quicklisp-quickstart:install)' \
        --eval '(let ((ql-util::*do-not-prompt* t)) (ql:add-to-init-file))'
RUN git clone https://github.com/eschulte/simpler-documentation-template /root/quicklisp/local-projects/simpler-documentation-template
RUN git clone https://github.com/brown/protobuf /root/quicklisp/local-projects/protobuf

COPY version.txt /gt/gtirb/version.txt
COPY proto /gt/gtirb/proto
COPY cl /gt/gtirb/cl

# Ensure all Common Lisp dependencies are installed before the build.
# Works around the fact that you can't run multiple Quicklisp dependency installs in parallel as done by 'make -j'.
RUN sbcl --eval '(asdf:initialize-source-registry `(:source-registry (:tree "/gt/gtirb/cl") :inherit-configuration))' \
        --eval '(ql:quickload :gtirb/test)' --eval '(sb-ext:exit)'
