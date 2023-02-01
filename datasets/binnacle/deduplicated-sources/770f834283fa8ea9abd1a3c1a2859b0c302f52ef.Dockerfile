FROM archlinux/base
RUN pacman --noconfirm -Sy archlinux-keyring && \
    pacman --noconfirm -S expect sed tar arch-install-scripts && \
    pacman -Scc
ADD ./build.sh /usr/local/bin
ADD ./build-helper.sh /usr/local/bin
ADD ./build-pacman.conf /usr/local/etc
ADD https://www.blackarch.org/strap.sh /usr/local/bin
RUN chmod u+x /usr/local/bin/strap.sh
VOLUME ["/output"]
WORKDIR /output
ENTRYPOINT ["/usr/local/bin/build.sh"]
