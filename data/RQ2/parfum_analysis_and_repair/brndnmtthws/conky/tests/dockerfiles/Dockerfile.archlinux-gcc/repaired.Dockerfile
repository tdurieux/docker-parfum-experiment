ARG IMAGE=registry.gitlab.com/brndnmtthws-oss/conky
FROM ${IMAGE}/builder/archlinux-base:latest

RUN pacman -Syu --noconfirm --needed \
  gcc