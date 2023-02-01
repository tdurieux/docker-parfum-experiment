from dyne/devuan:beowulf
maintainer jaromil "https://github.com/jaromil"

run echo "deb-src http://deb.devuan.org/merged beowulf main" > /etc/apt/sources.list
run echo "deb http://deb.devuan.org/merged beowulf main"    >> /etc/apt/sources.list
run apt-get -qq update && apt-get -yy --no-install-recommends install cmake && rm -rf /var/lib/apt/lists/*;
run apt-get build-dep -yy frei0r-plugins

copy . .

