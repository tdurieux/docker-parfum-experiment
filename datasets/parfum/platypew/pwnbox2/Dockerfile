FROM archlinux:latest

ENV USER pwnbox
ENV ZONE Asia
ENV SUBZONE Singapore

# Installing yay
RUN echo -e "[multilib]\nInclude = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf && \
    curl -fsSL "https://repo.archlinuxcn.org/x86_64/glibc-linux4-2.35-2-x86_64.pkg.tar.zst" | bsdtar -C / -xvf - && \
    pacman -Syyu --noconfirm && \
    pacman -S base-devel lib32-glibc git zsh reflector cmake vi man-db man-pages npm --noconfirm && \
    reflector -c $SUBZONE -a 24 -f 12 -l 10 -n 12 --save /etc/pacman.d/mirrorlist
RUN sed -i 's/# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/g' /etc/sudoers && \
    useradd -m -g users -G wheel -s /usr/bin/zsh $USER && \
    touch /home/$USER/.zshrc && \
    ln -sf /usr/share/zoneinfo/$ZONE/$SUBZONE /etc/localtime

# Enable systemd
RUN sudo pacman -Sy --noconfirm systemd systemd-sysvcompat
COPY ./config/docker-entrypoint.sh /

USER $USER
WORKDIR /home/$USER
RUN git clone https://aur.archlinux.org/yay.git && \
    cd yay && \
    makepkg -si --noconfirm

# Installing oh my zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" && \
    git clone https://github.com/zsh-users/zsh-autosuggestions.git /home/$USER/.oh-my-zsh/custom/plugins/zsh-autosuggestions && \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git /home/$USER/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting && \
    git clone https://github.com/b4b4r07/zsh-vimode-visual.git /home/$USER/.oh-my-zsh/custom/plugins/zsh-vimode-visual && \
    git clone https://github.com/DarrinTisdale/zsh-aliases-exa.git /home/$USER/.oh-my-zsh/custom/plugins/zsh-aliases-exa && \
    git clone https://github.com/hlissner/zsh-autopair.git /home/$USER/.oh-my-zsh/custom/plugins/zsh-autopair

COPY ./config/zshrc /home/$USER/.zshrc
COPY ./config/agnoster-dracula.zsh-theme /home/$USER/.oh-my-zsh/custom/themes/agnoster-dracula.zsh-theme
COPY ./config/tmux.conf /home/$USER/.tmux.conf

# Installing QoL stuff
RUN yay -S neovim exa wget bat fzf ripgrep tmux autojump strace net-tools iputils wget ltrace mlocate python2-pip ufw \
    python-pip python-virtualenv unzip unrar pigz p7zip nodejs yarn ruby rubygems openssh reflector openvpn --noconfirm && \
    pip install --user --upgrade neovim && \
    sudo npm install -g arch-wiki-man && \
    curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs\
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim && \
    mkdir -p /home/$USER/.config/nvim && \
    sudo setcap cap_net_raw+ep /usr/sbin/ping
COPY ./config/init.vim /home/$USER/.config/nvim
RUN sed '/call plug#end/q' /home/$USER/.config/nvim/init.vim > /home/$USER/.config/nvim/temp.vim && \
    nvim -u /home/$USER/.config/nvim/temp.vim --headless +PlugInstall +qall && \
    rm -f /home/$USER/.config/nvim/temp.vim && \
    sudo touch /usr/include/stropts.h

# Change permissions
RUN sudo chown $USER:users /home/$USER/.zshrc \
    /home/$USER/.oh-my-zsh/custom/themes/agnoster-dracula.zsh-theme \
    /home/$USER/.config/nvim/init.vim \
    /home/$USER/.tmux.conf

# Install blackarch repo and tools
RUN curl -fsSL https://blackarch.org/strap.sh | sudo sh && \
    yay -S afl r2ghidra ropper shellnoob wcc binwalk foremost gnu-netcat \
    python-gmpy2 xortool gobuster john exploitdb hexedit pwndbg \
    sqlmap z3 jad metasploit nmap perl-image-exiftool mitmproxy \
    factordb-pycli featherduster rsactftool ngrok autorecon rustscan --noconfirm && \
    echo "source /usr/share/pwndbg/gdbinit.py" >> /home/$USER/.gdbinit && \
    pip install --user --upgrade pycrypto sagemath pwntools \
    git+https://github.com/calebstewart/pwncat.git && \
    gem install zsteg one_gadget && \
    mkdir -p /home/$USER/.local/bin /home/$USER/.local/share && \
    ln -s /usr/bin/vendor_perl/exiftool /home/$USER/.local/bin && \
    git clone https://github.com/niklasb/libc-database.git /home/$USER/.local/share/libc-database && \
    mkdir -p /home/$USER/.local/share/yafu && \
    wget "https://udomain.dl.sourceforge.net/project/yafu/1.34/yafu-1.34.zip?viasf=1" -O /home/$USER/yafu-1.34.zip && \
    unzip /home/$USER/yafu-1.34.zip -d /home/$USER/.local/share/yafu && chmod +x /home/$USER/.local/share/yafu/yafu && \
    rm -f /home/$USER/yafu-1.34.zip /home/$USER/.local/share/yafu/*.exe && ln -sf /home/$USER/.local/share/yafu/yafu /home/$USER/.local/bin/yafu && \
    sudo setcap cap_net_raw,cap_net_admin,cap_net_bind_service+eip /usr/sbin/nmap

# Create shared directories
RUN sudo mkdir -p /mnt/shared && ln -s /mnt/shared /home/$USER/shared

# Cleanup
RUN yay -Scc --noconfirm && \
    yay -Rsc $(yay -Qtdq) --noconfirm && \
    sudo rm -rf /home/$USER/yay /home/$USER/.zshrc.pre-oh-my-zsh \
    /home/$USER/.zsh_history /home/$USER/.bash_profile \
    /home/$USER/.bash_logout /home/$USER/.cache /home/$USER/bin \
    /home/$USER/.cargo /home/$USER/.gem/ruby/2.7.0/cache /tmp/* /var/cache && \
    sudo updatedb

# Start systemd
USER root
ENTRYPOINT ["/docker-entrypoint.sh"]
