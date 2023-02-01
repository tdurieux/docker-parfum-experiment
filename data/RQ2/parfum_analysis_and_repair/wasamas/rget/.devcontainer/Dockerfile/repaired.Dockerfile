FROM ruby:3
ENV USER vscode
LABEL maintainer "@tdtds <t@tdtds.jp>"
RUN apt-get -y update && apt-get -y --no-install-recommends install ffmpeg && \
    curl -f -sLo /usr/local/bin/youtube-dl https://www.yt-dl.org/downloads/latest/youtube-dl && \
    chmod +x /usr/local/bin/youtube-dl && \
    useradd -u 1000 -m $USER && chsh -s /bin/bash $USER && rm -rf /var/lib/apt/lists/*;
USER $USER
RUN bundle config set path vendor/bundle && \
    bundle config set with development:test && \
    echo 'git config --global --unset core.editor' >> /home/$USER/.bashrc && \
    echo 'git config --global --unset core.sshCommand' >> /home/$USER/.bashrc && \
    echo 'git ls-remote -q > /dev/null' >> /home/$USER/.bashrc
CMD [ "sleep", "infinity" ]
