#    Samba Docker Container
#    Copyright (C) 2014-2019  David Personette
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU Affero General Public License as published
#    by the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU Affero General Public License for more details.
#
#    You should have received a copy of the GNU Affero General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.

FROM alpine
MAINTAINER David Personette <dperson@gmail.com>

# Install samba
RUN apk --no-cache --no-progress upgrade && \
    apk --no-cache --no-progress add bash samba shadow tini && \
    adduser -D -G users -H -S -g 'Samba User' -h /tmp smbuser && \
    file="/etc/samba/smb.conf" && \
    sed -i 's|^;* *\(log file = \).*|   \1/dev/stdout|' $file && \
    sed -i 's|^;* *\(load printers = \).*|   \1no|' $file && \
    sed -i 's|^;* *\(printcap name = \).*|   \1/dev/null|' $file && \
    sed -i 's|^;* *\(printing = \).*|   \1bsd|' $file && \
    sed -i 's|^;* *\(unix password sync = \).*|   \1no|' $file && \
    sed -i 's|^;* *\(preserve case = \).*|   \1yes|' $file && \
    sed -i 's|^;* *\(short preserve case = \).*|   \1yes|' $file && \
    sed -i 's|^;* *\(default case = \).*|   \1lower|' $file && \
    sed -i '/Share Definitions/,$d' $file && \
    echo '   pam password change = yes' >>$file && \
    echo '   map to guest = bad user' >>$file && \
    echo '   usershare allow guests = yes' >>$file && \
    echo '   create mask = 0664' >>$file && \
    echo '   force create mode = 0664' >>$file && \
    echo '   directory mask = 0775' >>$file && \
    echo '   force directory mode = 0775' >>$file && \
    echo '   force user = smbuser' >>$file && \
    echo '   force group = users' >>$file && \
    echo '   follow symlinks = yes' >>$file && \
    echo '   load printers = no' >>$file && \
    echo '   printing = bsd' >>$file && \
    echo '   printcap name = /dev/null' >>$file && \
    echo '   disable spoolss = yes' >>$file && \
    echo '   socket options = TCP_NODELAY' >>$file && \
    echo '   strict locking = no' >>$file && \
    echo '   vfs objects = acl_xattr catia fruit recycle streams_xattr' \
                >>$file && \
    echo '   recycle:keeptree = yes' >>$file && \
    echo '   recycle:maxsixe = 0' >>$file && \
    echo '   recycle:repository = .deleted' >>$file && \
    echo '   recycle:versions = yes' >>$file && \
    echo '' >>$file && \
    echo '   # Security' >>$file && \
    echo '   client ipc max protocol = default' >>$file && \
    echo '   client max protocol = default' >>$file && \
    echo '   server max protocol = SMB3' >>$file && \
    echo '   client ipc min protocol = default' >>$file && \
    echo '   client min protocol = CORE' >>$file && \
    echo '   server min protocol = SMB2' >>$file && \
    echo '' >>$file && \
    echo '   # Time Machine' >>$file && \
    echo '   durable handles = yes' >>$file && \
    echo '   kernel oplocks = no' >>$file && \
    echo '   kernel share modes = no' >>$file && \
    echo '   posix locking = no' >>$file && \
    echo '   fruit:aapl = yes' >>$file && \
    echo '   fruit:advertise_fullsync = true' >>$file && \
    echo '   fruit:time machine = yes' >>$file && \
    echo '   smb2 leases = yes' >>$file && \
    echo '   aio read size = 0' >>$file && \
    echo '   aio write size = 0' >>$file && \
    echo '' >>$file && \
    rm -rf /tmp/*

HEALTHCHECK --interval=60s --timeout=15s \
            CMD smbclient -L '\\localhost' -U '%' -m SMB3

VOLUME ["/etc", "/var/cache/samba", "/var/lib/samba", "/var/log/samba",\
            "/run/samba"]

ENTRYPOINT ["/sbin/tini", "--", "/usr/bin/samba.sh"]

