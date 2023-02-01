FROM ocaml/opam2:fedora

RUN \
    sudo dnf install -y \
    gtk+-devel \
    glib-devel \
    gobject-introspection-devel \
    xorg-x11-server-Xvfb \
    darcs \
    mercurial \
    m4 \
    openssl-devel \
    readline-devel \
    zlib-devel \
    dejavu-sans-fonts \
    gnome-icon-theme \
    adwaita-gtk2-theme \
    vte3 \
    vte3-devel \
    clutter-gtk \
    gtksourceview3 \
    dbus-x11 \
    wget

COPY . /home/opam/tests
RUN sudo chown -R opam:opam /home/opam/tests
WORKDIR /home/opam/tests
RUN opam switch $OCAML_VERSION
RUN eval $(opam env)
RUN ./travis/initialize_ocaml_environment.sh
RUN ./travis/show_versions.sh
CMD bash -ex ./travis/runtest.sh
