FROM wesnoth/wesnoth:2204-master

RUN apt update && apt install --no-install-recommends -y flatpak flatpak-builder jq && rm -rf /var/lib/apt/lists/*; # install flatpak

RUN flatpak remote-add flathub https://flathub.org/repo/flathub.flatpakrepo
# install runtime
RUN flatpak install -y flathub org.freedesktop.Platform/x86_64/21.08 org.freedesktop.Sdk/x86_64/21.08
