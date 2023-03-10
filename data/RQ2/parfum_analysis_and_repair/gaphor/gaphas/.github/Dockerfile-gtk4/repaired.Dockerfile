FROM fedora:36

ENV TEST_GTK_VERSION "4.0"

RUN dnf install -y util-linux poetry gcc gtk4 cairo-devel cairo-gobject-devel gobject-introspection-devel python3-devel python3-pip xorg-x11-server-Xvfb

WORKDIR /work

COPY . /work/

RUN poetry install && poetry run xvfb-run pytest --cov=gaphas