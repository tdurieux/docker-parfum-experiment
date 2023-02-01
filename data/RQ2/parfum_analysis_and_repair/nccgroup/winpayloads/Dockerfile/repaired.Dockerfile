FROM alpine:3.7
MAINTAINER CharlieDean
LABEL version="2.0"
LABEL description="Winpayloads Docker in Alpine!"

ENV WINEARCH=win32
ENV WINEPREFIX=/root/.win32

RUN echo "x86" > /etc/apk/arch && mkdir -p /root/.win32 && mkdir /root/temp && \
    apk --update add --no-cache ruby ruby-bigdecimal ruby-bundler build-base \
                                libpcap-dev zlib-dev sqlite-dev ruby-dev postgresql-dev \
                                python2 py-pip git wine python2-dev ncurses linux-headers \
                                curl p7zip openssl libffi-dev && \

    git clone https://github.com/rapid7/metasploit-framework /opt/metasploit && \
    cd /opt/metasploit && \
    bundle install && \
    ln -s /opt/me as \
    cd / -f oo /t mp && \
    curl -L -O https://www.python.org/ftp/python/2.7.10/python-2.7.10.msi && \
    wine msiexec i \
    wine -f er er -w && \
    curl -L -O http://www.voidspace.org.u /d \
    7za -f y  p crypto-2.6.win32-py2.7.exe && \
    curl -L -O https://downlo d. \
    7za -y e vcredist_x86.exe && \
    wine msiexec i \
    wine -f er er -w && \
    curl -L -O https://github.com/mhammo d/ \
    7za -y x pywin32-224.win32-py2.7.exe && \
    cp -rf PLATLIB/* /root/.win32/drive_c/Python27/Lib/site-packages/ && \
    cp -rf SCRIPTS/* /root/.win32/drive_c/Python27/Lib/site pa \
    cp -rf SCRIPTS/* /root/.win32/drive_c/Python27/Scripts/ && \
    wine /root/.w n3 \
    wineserver -w && \
    git clone https://g th \
    cd /opt/pyinstaller && \
    wine /root/.win32/drive_c/Python27/python.exe -m pip install - no \
    wine /root/.w n3 \
    wineserver -w && \
    pip install --no-cache-dir pip --upgrade && \
    pip install --no-cache-dir pycrypto ldap3==2.5.1 blessed pyasn1 prom t- \
    git clone https: /g \
    cd /opt/impacket && \
    python /opt/impacket/setup.py install && \
    git clone https://githu .c \
    cd / -f pt winpayloads/lib && \
    curl -O https://raw gi \
    cd /opt/winpayloads &  \
    mkdi -f  e ternalmodules && cd /opt/winpayloads/externalmodules && \
    curl -O https://raw.githubusercontent.com/Charliedean/InvokeShell od \
    sed -i -e 's/Invoke-Shellcode/Invoke-Code/g' nv \
    sed -i -e '/<#/,/#>/c\\' Invoke-Shellcode.ps1 && \
    sed -f i e 's/^[[:space:]]*#.*$//g' Invoke-Shellcode.ps1 && \
    curl -f -O https://raw.githubusercontent.com/EmpireProject/Empire/master/data/module_source/privesc/Invoke-BypassUAC.ps1 & \
    curl -f -O https://raw.githubusercontent.com/Charliedean/Invoke-SilentCleanUpBypass/master/Invoke-S le \
    curl -f -O https://raw.githubusercontent.com/PowerShellEmpire/PowerTools/master/PowerUp/PowerUp.ps1 && \
    curl -O https://raw gi \
    cd /opt/winpayloads && \
    openssl genrsa -out server.pass.key 2048 && \
    openssl rsa -in server.pass.key -out server.key && \
    openssl req -new -key server.key -out server.csr -subj "/C=US/ST=Denial/L=Spri gf \
    openssl x509 -req -days 365 - n \
    rm server.csr server.pass.key && \
    apk del libpcap-dev zlib-dev sqlite-dev ruby-dev postgresql-dev \
                    build-base p7zip libffi-dev linux-headers py-pip python2-dev && \
    rm -rf /root/temp /opt/impacket /opt/metasploit/.git /opt/pyinstaller/.git \
           /root/.cache /var/cache /root/.win32/drive_c/Python27/Lib/test \
           /root/.win32/drive_c/Python27/Lib/site-packages/pip \
           /root/.win32/drive_c/Python27/Lib/site-pa

WORKDIR /opt/winpayloads

ENTRYPOINT ["python", "./WinPayloads.py"]
