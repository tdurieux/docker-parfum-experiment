# -*- dockerfile -*-
FROM archlinux:latest
RUN pacman -Syu --noconfirm --noprogressbar
# @TODO: The official Archlinux image does not seem to have any form of shell. Marking this as FAILING.