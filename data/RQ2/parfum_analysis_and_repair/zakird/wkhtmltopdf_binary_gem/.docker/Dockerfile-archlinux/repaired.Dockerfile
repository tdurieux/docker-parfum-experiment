FROM archlinux

ENV DEBIAN_FRONTEND noninteractive

RUN pacman -Sy --noconfirm ruby fontconfig freetype2 libjpeg libpng libxext libxrender

CMD /root/wkhtmltopdf_binary_gem/bin/wkhtmltopdf --version