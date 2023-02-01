# Some inspiration taken from OMI repo sample Dockerfile
# https://raw.githubusercontent.com/microsoft/omi/master/docker/release/ubuntu16.04/Dockerfile
FROM ubuntu:18.04

ARG BOLT_PASSWORD=bolt

RUN useradd bolt \
 && echo "bolt:${BOLT_PASSWORD}" | chpasswd

# install Microsoft package repo for access to omi and powershell packages
# gss-ntlmssp is for OMI server, remaining packages are for .NET Core / PowerShell
# PSRP deb provides OMI "plugin" for PowerShell
RUN export DEBIAN_FRONTEND=noninteractive \
 && apt-get update -y \
 && apt-get install -y wget \
 && wget http://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb \
 && dpkg -i packages-microsoft-prod.deb \
 && apt-get update -y \
 && apt-get install -y \
    gss-ntlmssp \
    libgssapi-krb5-2 \
    omi \
    powershell \
 && wget https://github.com/PowerShell/psl-omi-provider/releases/download/v1.4.2-2/psrp-1.4.2-2.universal.x64.deb \
 && dpkg -i psrp-1.4.2-2.universal.x64.deb

# Configure ports 5985 and 5986 with OMI
# and enable the NTLM auth file
# write to temp first to avoid writing empty omiserver.conf
RUN cat /etc/opt/omi/conf/omiserver.conf \
 | /opt/omi/bin/omiconfigeditor httpport --add 5985 \
 | /opt/omi/bin/omiconfigeditor httpsport --add 5986 \
 | /opt/omi/bin/omiconfigeditor NtlmCredsFile --set '/etc/opt/omi/creds/ntlm' \
 | /opt/omi/bin/omiconfigeditor NtlmCredsFile --uncomment \
 >tmp.conf \
 && mv -f tmp.conf /etc/opt/omi/conf/omiserver.conf

# Well known certs for use in specs installed to default OMI location
COPY fixtures/ssl/cert.pem /etc/opt/omi/ssl/omi.pem
COPY fixtures/ssl/key.pem /etc/opt/omi/ssl/omikey.pem

# https://github.com/Microsoft/omi/blob/master/Unix/doc/setup-ntlm-omi.md
# mechanism file at /etc/gss/mech.d/mech.ntlmssp.conf is already properly configured
# gssntlmssp_v1           1.3.6.1.4.1.311.2.2.10          /usr/lib/x86_64-linux-gnu/gssntlmssp/gssntlmssp.so
# setup the NTLM auth file with proper ownership and perms
# setup SSL public / private key with proper ownership
# adding the bolt user to NTLM authentication file
RUN touch /etc/opt/omi/creds/ntlm \
 && echo ":bolt:$BOLT_PASSWORD" >> /etc/opt/omi/creds/ntlm \
 && chown -R omi:omi /etc/opt/omi/creds \
 && chmod 500 /etc/opt/omi/creds \
 && chmod 600 /etc/opt/omi/creds/ntlm \
 && chown omi:omi /etc/opt/omi/ssl/omikey.pem

EXPOSE 5985 5986

ADD fixtures/omiserver/docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
