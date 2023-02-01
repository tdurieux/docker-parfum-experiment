ARG REGISTRY

FROM "$REGISTRY/common/gitlab-helper/archlinux-yay:master"

RUN (\
    yay -Syuq --noconfirm --needed openjpeg2 netcdf \
    && yes | yay -Scc --noconfirm \
    && sudo rm -rf /var/cache/pacman/pkg/* \
)