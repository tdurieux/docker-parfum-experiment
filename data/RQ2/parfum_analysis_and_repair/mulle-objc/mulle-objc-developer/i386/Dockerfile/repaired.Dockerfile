FROM ioft/i386-ubuntu:xenial

# make it fresh
# add en UTF-8 as a locale
RUN DEBIAN_FRONTEND=noninteractive \
   && apt-get update \
   && apt-get -y --no-install-recommends install locales \
   && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && locale-gen \
   && apt-get -y --no-install-recommends install gnupg sudo apt-utils lsb-release wget \

   && wget -O - https://www.codeon.de/dists/codeon-pub.asc | apt-key add - \
   && echo "deb [arch=i386] http://download.codeon.de `lsb_release -c -s` main" | tee /etc/apt/sources.list.d/codeon.de-main.list > /dev/null \

   && wget -O - https://www.mulle-kybernetik.com/dists/debian-admin-pub.asc | apt-key add - \
   && echo "deb [arch=all] http://www.mulle-kybernetik.com `lsb_release -c -s` main" | tee "/etc/apt/sources.list.d/mulle-kybernetik.com-main.list" > /dev/null \

   && apt-get update \
   && apt-get -y --no-install-recommends install mulle-objc-developer && rm -rf /var/lib/apt/lists/*;
