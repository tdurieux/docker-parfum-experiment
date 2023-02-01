from dyne/devuan:ascii
maintainer parazyd "https://github.com/parazyd"

run echo "deb-src http://deb.devuan.org/merged ascii main" > /etc/apt/sources.list
run echo "deb http://deb.devuan.org/merged ascii main"    >> /etc/apt/sources.list
run apt-get -qq update && apt-get -yy install zsh cgpt parted xz-utils qemu qemu-utils python-markdown ruby-ronn --no-install-recommends && rm -rf /var/lib/apt/lists/*;
copy . .
run git submodule update --init --recursive --checkout

