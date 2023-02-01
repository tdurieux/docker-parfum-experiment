# Molecule managed

FROM {{ item.image }}

RUN if [ $(command -v apt-get) ]; then \
 apt-get update && apt-get upgrade -y && apt-get install --no-install-recommends -y python3 sudo bash ca-certificates && apt-get clean; rm -rf /var/lib/apt/lists/*; \
    elif [ $(command -v dnf) ]; then dnf makecache && dnf --assumeyes install python3 sudo python3-devel python3-dnf bash && dnf clean all; \
    elif [ $(command -v zypper) ]; then zypper refresh && zypper update -y && zypper install -y python3 sudo bash python3-xml && zypper clean -a; \
    elif [ $(command -v apk) ]; then apk update && apk add --no-cache python3 sudo bash ca-certificates; fi
