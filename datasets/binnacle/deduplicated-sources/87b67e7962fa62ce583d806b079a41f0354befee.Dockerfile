FROM archlinux/base
WORKDIR /opt/oomox-build/

# App and test (xvfb, pylint) deps
RUN pacman -Syu --noconfirm && \
    pacman -S --needed --noconfirm gtk3 python-gobject python-yaml flake8 python-pylint xorg-server-xvfb mypy shellcheck && \
    pacman -S --needed --noconfirm git base-devel && \
    useradd -m user && \
    echo "user ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    sudo -u user bash -c "\
        git clone https://aur.archlinux.org/pikaur /home/user/pikaur && \
        cd /home/user/pikaur && \
        makepkg --install --syncdeps --noconfirm" && \
    sudo -u user pikaur -S --noconfirm python-pystache python-vulture

COPY . /opt/oomox-build/

# vim: set ft=dockerfile :
