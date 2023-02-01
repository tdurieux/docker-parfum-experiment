#USER root

# Make everything created in /root (e.g. virtualenv stuff in /root/venv) accessible by anyone.
# This is to avoid having to do this at container startup, since it takes a long time
# (especially for /root/venv).
#RUN chmod -R ugo+rwx /root

USER root
# Install custom /etc/bash.bashrc to display rlscope-banner