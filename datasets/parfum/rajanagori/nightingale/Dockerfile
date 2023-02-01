## Taking Image from Docker Hub for Programming language support
FROM rajanagori/nightingale_programming_image:v1

LABEL maintainer="Raja Nagori" \
    email="raja.nagori@owasp.org"
    
ARG DEBIAN_FRONTEND=noninteractive

USER root
## Banner shell and run shell file ##
COPY \
    shells/banner.sh /tmp/banner.sh

COPY \
    configuration/source /tmp/source

RUN \
    cat /tmp/banner.sh >> /root/.bashrc && \
    cat /tmp/source >> /etc/apt/sources.list &&\

#### Installing os tools and other dependencies.
    apt-get -y update --fix-missing && \
    apt-get -f --no-install-recommends install -y \
    #### Operating system dependecies start
    software-properties-common \
    ca-certificates \
    build-essential \
    ### Operating System Tools start here 
    locate \
    snapd \
    tree \
    zsh \
    figlet \
    ### Compression Techniques starts
    unzip \
    p7zip-full \
    ftp \
    ### Dev Essentials start here
    ssh \
    git \
    curl \
    wget \
    ### Web Vapt tools using apt-get
    dirb \
    ## INstalling Network Tools using apt-get
    nmap \
    htop \
    traceroute \
    telnet \
    net-tools \
    iputils-ping \
    tcpdump \
    openvpn \
    whois \
    host \
    tor \
    john \
    cewl \
    hydra \
    medusa \
    figlet \
    dnsutils \
    # Some android architecture dependency
    android-framework-res \
    # installing Apktool and adb
    adb \
    apktool \
    ## Installing tools using apt-get for forensics and objection install
    exiftool \
    steghide \
    binwalk \
    foremost && \
    pip install objection &&\
    # Cleaning Unwanted libraries 
    apt-get -y autoremove &&\
    apt-get -y clean &&\
    rm -rf /tmp/* &&\
    rm -rf /var/lib/apt/lists/*

COPY \
    shells/node-installation-script.sh /temp/node-installation-script.sh
RUN \
    chmod +x /temp/node-installation-script.sh && /temp/node-installation-script.sh &&\

### Creating Directories
    cd /home &&\
    mkdir -p tools_web_vapt tools_osint tools_mobile_vapt tools_network_vapt tools_red_teaming tools_forensics wordlist binaries .gf .shells

## Environment for Directories
ENV TOOLS_WEB_VAPT=/home/tools_web_vapt/
ENV BINARIES=/home/binaries/
ENV GREP_PATTERNS=/home/.gf
ENV TOOLS_OSINT=/home/tools_osint/
ENV TOOLS_MOBILE_VAPT=/home/tools_mobile_vapt/
ENV TOOLS_NETWORK_VAPT=/home/tools_network_vapt/
ENV TOOLS_RED_TEAMING=/home/tools_red_teaming/
ENV TOOLS_FORENSICS=/home/tools_forensics/
ENV WORDLIST=/home/wordlist/
ENV METASPLOIT_CONFIG=/home/metasploit_config/
ENV METASPLOIT_TOOL=/home/metasploit
ENV SHELLS=/home/.shells/

COPY \
    --from=rajanagori/nightingale_web_vapt_image:v1.0 ${TOOLS_WEB_VAPT} ${TOOLS_WEB_VAPT}
RUN true
COPY \
    --from=rajanagori/nightingale_web_vapt_image:v1.0 ${GREP_PATTERNS} ${GREP_PATTERNS}
RUN true
COPY \
    --from=rajanagori/nightingale_osint_image:v1.0 ${TOOLS_OSINT} ${TOOLS_OSINT}
RUN true
COPY \
    --from=rajanagori/nightingale_mobile_vapt_image:v1.0 ${TOOLS_MOBILE_VAPT} ${TOOLS_MOBILE_VAPT}
RUN true
COPY \
    --from=rajanagori/nightingale_network_vapt_image:v1.0 ${TOOLS_NETWORK_VAPT} ${TOOLS_NETWORK_VAPT}
RUN true
COPY \
    --from=rajanagori/nightingale_forensic_and_red_teaming:v1.0 ${TOOLS_RED_TEAMING} ${TOOLS_RED_TEAMING} 
RUN true
COPY \
    --from=rajanagori/nightingale_forensic_and_red_teaming:v1.0 ${TOOLS_FORENSICS} ${TOOLS_FORENSICS}
RUN true
COPY \
    --from=rajanagori/nightingale_wordlist_image:v1.0 ${WORDLIST} ${WORDLIST}
RUN true
COPY \
    configuration/modules-installation ${SHELLS}

RUN \
    cd ${SHELLS}&& \
    chmod +x *.sh && \
    ./python-install-modules.sh && \
    ./go-install-modules.sh

## All binaries will store here
WORKDIR ${BINARIES}
## INstallation stuff
COPY \
    binary/ ${BINARIES}
    
RUN \
    chmod +x ${BINARIES}/* && \
    mv assetfinder /usr/local/bin/ && \
    mv gau /usr/local/bin/ && \
    mv gf /usr/local/bin/ && \
    mv httprobe /usr/local/bin/ && \
    mv httpx /usr/local/bin/ && \
    mv jadx /usr/local/bin/ && \
    mv nuclei /usr/local/bin/ && \
    mv qsreplace /usr/local/bin/ && \
    mv subfinder /usr/local/bin/ && \
    mv waybackurls /usr/local/bin/ && \
    mv ffuf /usr/local/bin/ && \
    mv findomain /usr/local/bin/ && \
    mv gobuster /usr/local/bin/ && \
    mv masscan /usr/local/bin/ && \
    mv amass /usr/local/bin/ && \
    wget -L https://github.com/RAJANAGORI/Nightingale/blob/main/binary/ttyd?raw=true -O ttyd && \
    chmod +x ttyd

## Installing metasploit
WORKDIR ${METASPLOIT_TOOL}
### Installing Metasploit-framework start here
## PosgreSQL DB
COPY configuration/msf-configuration/scripts/db.sql .

## Startup script
COPY configuration/msf-configuration/scripts/init.sh /usr/local/bin/init.sh
## Installation of msf framework
RUN \
    wget -L https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb -O msfinstall && \
    chmod 755 msfinstall && \
    ./msfinstall
## DB config
COPY ./configuration/msf-configuration/conf/database.yml ${METASPLOIT_CONFIG}/metasploit-framework/config/ 

CMD "./configuration/msf-configuration/scripts/init.sh"

# Expose the service ports
EXPOSE 5432
EXPOSE 8080
EXPOSE 8081
EXPOSE 7681

### Working Directory of tools ends here
WORKDIR /home