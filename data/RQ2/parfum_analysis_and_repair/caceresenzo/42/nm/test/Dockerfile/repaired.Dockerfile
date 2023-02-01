FROM debian

RUN apt update && apt install --no-install-recommends -y nano make gcc g++ binutils zsh wget curl git gcc-multilib g++-multilib file rsync xz-utils ncurses-dev texinfo && rm -rf /var/lib/apt/lists/*;
RUN yes | sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

WORKDIR /app
