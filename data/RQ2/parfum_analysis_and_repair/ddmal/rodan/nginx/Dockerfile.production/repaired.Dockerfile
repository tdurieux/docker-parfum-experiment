FROM ddmal/nginx:nightly
ARG SERVER_HOST

# [TODO] Run basic config test. It will check to make sure hosts upstream are online.
# But health checks will reboot the current instance, and not others. Do not only rely on this.
# HEALTHCHECK --interval=5m --timeout=3s \
#   CMD service nginx configtest || exit 1