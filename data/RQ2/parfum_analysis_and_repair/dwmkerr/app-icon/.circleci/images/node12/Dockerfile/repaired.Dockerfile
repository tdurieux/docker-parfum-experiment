FROM circleci/node:12

# Install IM and the CAB extract util to unpack windows fonts.
RUN sudo apt-get update -y \
    && sudo apt-get install --no-install-recommends -y curl tar file xz-utils build-essential \
    cabextract \
    imagemagick && rm -rf /var/lib/apt/lists/*;

# Unpack fonts. Needed as ImageMagick uses a default font (Arial) if we do
# not explicitly specify one.
RUN cd ~; wget -c https://www.freedesktop.org/software/fontconfig/webfonts/webfonts.tar.gz -O - | tar -xz
RUN cd ~; cabextract ~/msfonts/*.exe
RUN mkdir -p ~/.local/share/fonts
RUN cd ~; cp *.ttf *.TTF ~/.local/share/fonts

