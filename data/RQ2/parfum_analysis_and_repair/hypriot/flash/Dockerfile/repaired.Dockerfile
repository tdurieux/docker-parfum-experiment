FROM node:8
WORKDIR /code/
COPY package.json .
RUN npm install && \
    mv node_modules .. && npm cache clean --force;

RUN apt-get update && apt-get install --no-install-recommends -y sudo pv curl unzip shellcheck udev && rm -rf /var/lib/apt/lists/*;
RUN useradd user && \
    mkdir -p /home/user && \
    chown user:users /home/user && \
    echo "user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
RUN echo "#!/bin/bash\necho 1\n" >/sbin/hdparm && chmod +x /sbin/hdparm
RUN cp "$(which mount)" "$(which mount).real" && \
    echo "#!/bin/bash\nmnt=\$(echo \$3 | sed 's/1\$//')\noffset=\$(fdisk -l \$mnt | grep -i fat | awk '{print \$2*512}')\nsudo mount.real -o loop,offset=\$offset,uid=user,gid=user \$mnt \$4\n" >$(which mount)

USER user
CMD [ "npm", "test" ]
