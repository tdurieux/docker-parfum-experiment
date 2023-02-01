# Use the maximum Python version tested
FROM python:3.10-slim

# linkchecker creates ~/.linkchecker/ (700) containing linkcheckerrc et al
ENV HOME /tmp

# Enables access to local files when run with -v "$PWD":/mnt
VOLUME /mnt

WORKDIR /mnt

# Dependencies change on their own schedule so install them separately