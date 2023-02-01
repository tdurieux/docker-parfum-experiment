FROM ubuntu:20.04

COPY unified-supervisord.conf supervisord.conf /etc/supervisord/
COPY mc.ini /home/abc/.config/mc/ini
COPY zsh-in-docker.sh /tmp/zsh-in-docker.sh

# Systemctl within Docker and Python 3.9
RUN DEBIAN_FRONTEND=noninteractive apt-get -y update \ 
    && echo "------------------------------------------------------ Common stuff" \
    && apt-get install --no-install-recommends -y sudo curl wget telnet jq \
    && apt-get install --no-install-recommends -y software-properties-common \
    && apt-get install --no-install-recommends -y zip gzip tar \
    && echo "------------------------------------------------------ docker systemctl replacement" \
    && wget https://raw.githubusercontent.com/gdraheim/docker-systemctl-replacement/master/files/docker/systemctl3.py -O /usr/local/bin/systemctl \
    && chmod 0777 /usr/local/bin/systemctl \
    && echo "------------------------------------------------------ User" \
    && useradd -u 8877 abc \
    && chmod -R 777 /home \
    && mkdir -p /home/abc \
    && chown -R abc /home/abc \
    && echo "------------------------------------------------------ Python" \
    && apt-get install --no-install-recommends -y python3-distutils \
    && apt-get install --no-install-recommends -y python3-pip \
    && apt-get install --no-install-recommends -y python3-venv \
    && pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir --upgrade setuptools \
    && pip install --no-cache-dir --upgrade distlib \
    && update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 1 \
    && echo "------------------------------------------------------ Allow users some priviledged actions" \
    && echo "# Allow non-admin users to install packages" >> /etc/sudoers \
    && echo "abc ALL = NOPASSWD : /usr/bin/apt, /usr/bin/apt-get, /usr/bin/aptitude, /usr/bin/add-apt-repository, /usr/local/bin/pip, /usr/local/bin/systemctl, /usr/bin/dpkg, /usr/sbin/dpkg-reconfigure" >> /etc/sudoers \
    && echo "------------------------------------------------------ GIT" \
    && apt-get install --no-install-recommends -y git git-flow \
    && wget -P /tmp https://github.com/jesseduffield/lazygit/releases/download/v0.34/lazygit_0.34_Linux_x86_64.tar.gz \
    && mkdir /tmp/lazygit && tar -xzf /tmp/lazygit_0.34_Linux_x86_64.tar.gz --directory /tmp/lazygit \
    && chmod +x /tmp/lazygit/lazygit \
    && mv /tmp/lazygit/lazygit /usr/bin/ \
    && rm /tmp/lazygit_0.34_Linux_x86_64.tar.gz \
    && rm -rf /tmp/lazygit \
    && echo "------------------------------------------------------ Nodeenv" \
    && pip install --no-cache-dir nodeenv \
    && apt-get install --no-install-recommends -y yarn \
    && echo "------------------------------------------------------ Cron" \
    && apt-get install --no-install-recommends -y cron \
    && mkdir -p /var/log/supervisord/ \
    && chmod -R 777 /var/spool/cron/crontabs \
    && chmod -R 777 /var/log \
    && chmod gu+rw /var/run \
    && chmod gu+s /usr/sbin/cron \
    && echo "# Allow cron for user abc" >> /etc/sudoers \
    && echo "abc ALL = NOPASSWD : /usr/sbin/cron " >> /etc/sudoers \
    && echo "------------------------------------------------------ Supervisor" \
    && apt-get remove -y cmdtest \
    && apt-get install --no-install-recommends -y supervisor \
    && pip3 install --no-cache-dir supervisor==4.2.2 \
    && apt-get -y update \
    && apt-get install --no-install-recommends -y systemd \
    && chmod -R 777 /etc/supervisord/ \
    && chmod -R 777 /var/log/supervisord/ \
    && echo "------------------------------------------------------ ZSH root" \
    && HOME=/root \
    && chmod +x /tmp/zsh-in-docker.sh \
    && /tmp/zsh-in-docker.sh \
    -t https://github.com/pascaldevink/spaceship-zsh-theme \
    -a 'SPACESHIP_PROMPT_ADD_NEWLINE="false"' \
    -a 'SPACESHIP_PROMPT_SEPARATE_LINE="false"' \
    -a 'export LS_COLORS="$LS_COLORS:ow=1;34:tw=1;34:"' \
    -a 'SPACESHIP_USER_SHOW="false"' \
    -a 'SPACESHIP_TIME_SHOW="true"' \
    -a 'SPACESHIP_TIME_COLOR="grey"' \
    -a 'SPACESHIP_DIR_COLOR="cyan"' \
    -a 'SPACESHIP_GIT_SYMBOL="⇡"' \
    -a 'SPACESHIP_BATTERY_SHOW="false"' \
    -a 'if [[ $(pwd) != /root  ]]; then cd /root; fi  # Set starting dir to /root ' \
    -a 'hash -d r=/root' \
    -p git \
    -p https://github.com/zsh-users/zsh-autosuggestions \
    -p https://github.com/zsh-users/zsh-completions \
    -p https://github.com/zsh-users/zsh-history-substring-search \
    -p https://github.com/zsh-users/zsh-syntax-highlighting \
    -p 'history-substring-search' \
    -p https://github.com/bobthecow/git-flow-completion \
    -a 'bindkey "\$terminfo[kcuu1]" history-substring-search-up' \
    -a 'bindkey "\$terminfo[kcud1]" history-substring-search-down' \
    && printf '%s\n%s\n' "export ZSH_DISABLE_COMPFIX=true" "$(cat /root/.zshrc)" > /root/.zshrc \
    && echo "------------------------------------------------------ ZSH abc" \
    && mkdir -p /home/project \
    && HOME=/home/abc \
    && /tmp/zsh-in-docker.sh \
    -t https://github.com/pascaldevink/spaceship-zsh-theme \
    -a 'DISABLE_UPDATE_PROMPT="true"' \
    -a 'SPACESHIP_PROMPT_ADD_NEWLINE="false"' \
    -a 'SPACESHIP_PROMPT_SEPARATE_LINE="false"' \
    -a 'export LS_COLORS="$LS_COLORS:ow=1;34:tw=1;34:"' \
    -a 'SPACESHIP_USER_SHOW="true"' \
    -a 'SPACESHIP_TIME_SHOW="true"' \
    -a 'SPACESHIP_TIME_COLOR="grey"' \
    -a 'SPACESHIP_DIR_COLOR="cyan"' \
    -a 'SPACESHIP_GIT_SYMBOL="⇡"' \
    -a 'SPACESHIP_BATTERY_SHOW="false"' \
    -a 'if [[ $(pwd) != /home/project  ]]; then cd /home/project; fi  # Set starting dir to /home/project ' \
    -a 'hash -d p=/home/project' \
    -p git \
    -p https://github.com/zsh-users/zsh-autosuggestions \
    -p https://github.com/zsh-users/zsh-completions \
    -p https://github.com/zsh-users/zsh-history-substring-search \
    -p https://github.com/zsh-users/zsh-syntax-highlighting \
    -p 'history-substring-search' \
    -p https://github.com/bobthecow/git-flow-completion \
    -a 'bindkey "\$terminfo[kcuu1]" history-substring-search-up' \
    -a 'bindkey "\$terminfo[kcud1]" history-substring-search-down' \
    && rm /tmp/zsh-in-docker.sh \
    && printf '%s\n%s\n' "export ZSH_DISABLE_COMPFIX=true" "$(cat /home/abc/.zshrc)" > /home/abc/.zshrc \
    && echo "------------------------------------------------------ Code editors" \
    && apt-get install --no-install-recommends -y nano vim \
    && echo "------------------------------------------------------ File browsers: MC, Xplr" \
    && apt-get install --no-install-recommends -y mc \
    && wget -P /tmp https://github.com/sayanarijit/xplr/releases/download/v0.17.6/xplr-linux.tar.gz \
    && \mkdir /tmp/xplr && tar -xzf /tmp/xplr-linux.tar.gz --directory /tmp/xplr \
    && chmod +x /tmp/xplr/xplr \
    && mv /tmp/xplr/xplr /usr/bin/ \
    && rm /tmp/xplr-linux.tar.gz \
    && rm -rf /tmp/xplr \
    && echo "------------------------------------------------------ Sys monitoring: Glances, Vizex" \
    && apt-get install --no-install-recommends -y ncdu htop \
    && pip install --no-cache-dir glances==3.2.5 \
    && pip install --no-cache-dir vizex==2.1.0 \
    && echo "------------------------------------------------------ Web-based terminal" \
    && cd /tmp && wget https://github.com/tsl0922/ttyd/releases/download/1.6.3/ttyd.x86_64 \
    && mv ttyd.x86_64 /usr/bin/ttyd \
    && chmod +x /usr/bin/ttyd \
    && echo "------------------------------------------------------ utils" \
    && git clone https://github.com/bluxmit/alnoda-workspaces /tmp/alnoda-workspaces \
    && mv /tmp/alnoda-workspaces/utils /home/abc/ \
    && rm -rf /tmp/alnoda-workspaces \
    && echo "------------------------------------------------------ User" \
    && chown abc /home/project \
    && chmod 777 /etc/supervisord/ \
    && mkdir -p /home/abc/.local/bin \
    && chmod 755 /home/abc/.local && chmod 755 /home/abc/.local/bin \
    && chown abc /home/abc/.local && chown abc /home/abc/.local/bin \
    && find /home -type d | xargs -I{} chown -R abc {} \
    && find /home -type f | xargs -I{} chown abc {} \
    && echo "------------------------------------------------------ Aliases" \
    && echo 'alias python="python3"' >> /root/.zshrc \
    && echo 'alias python="python3"' >> /home/abc/.zshrc \
    && echo "------------------------------------------------------ Clean" \
    && apt-get -y autoremove \
    && apt-get -y clean \
    && apt-get -y autoclean \
    && rm -rf /home/abc/.oh-my-zsh/.git \
    && rm -rf /home/abc/.oh-my-zsh/.github \
    && rm -rf /home/abc/.oh-my-zsh/custom/plugins/git-flow-completion/.git \
    && rm -rf /home/abc/.oh-my-zsh/custom/plugins/zsh-autosuggestions/.git \
    && rm -rf /home/abc/.oh-my-zsh/custom/plugins/zsh-completions/.git \
    && rm -rf /home/abc/.oh-my-zsh/custom/plugins/zsh-history-substring-search/.git \
    && rm -rf /home/abc/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/.git \
    && rm -rf /home/abc/.oh-my-zsh/custom/themes/spaceship-zsh-theme/.git && rm -rf /var/lib/apt/lists/*;

USER abc

ENV PATH="/home/abc/.local/bin:${PATH}"

###### ENTRY

# note! this will have consequences only when started as root (docker run ... --user root ...) 
# systemctl start systemd-journald
#   I remove this from entrypoint, as it is not used significantly, but slows down the start

# this entrypoint should be the same for all images that are built on top of this one
ENTRYPOINT /etc/init.d/cron start; supervisord -c "/etc/supervisord/unified-supervisord.conf"
