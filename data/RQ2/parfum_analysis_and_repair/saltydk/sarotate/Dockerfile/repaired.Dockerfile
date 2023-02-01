FROM saltydk/ubuntu-s6overlay:latest

ARG DEBIAN_FRONTEND="noninteractive"

# install packages
RUN pip3 install --no-cache-dir apprise

RUN curl -f -L -o /app/SARotate $( curl -f -Ls https://api.github.com/repos/saltydk/sarotate/releases/latest | grep "browser_download_url" | cut -d '"' -f 4) && \
    chmod -R u=rwX,go=rX "/app" && \
    chmod +x /app/SARotate

COPY root/ /