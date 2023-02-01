ARG BASE_IMAGE_TAG

FROM wodby/alpine:${BASE_IMAGE_TAG}

ARG MARIADB_VER

ENV MARIADB_VER="${MARIADB_VER}" \
    BACKUPS_DIR="/mnt/backups"

COPY patches /tmp/patches

RUN set -xe; \
    \
    addgroup -g 101 -S mysql; \
	adduser -u 100 -D -S -s /bin/bash -G mysql mysql; \
	echo "PS1='\w\$ '" >> /home/mysql/.bashrc; \
    \
    apk add --update --no-cache -t .mariadb-run-deps \
        libaio \
        libstdc++ \
        linux-pam \
        make \
        pwgen \
        sudo \
        tzdata; \
    \
    apk add --update --no-cache -t .mariadb-build-deps \
        attr \
        autoconf \
        bison \
        build-base \
        cmake \
        coreutils \
        gnupg \
        libaio-dev \
        linux-pam-dev \
        # MariaDB 10.1 does not support OpenSSL 1.1.
        $(test "${MARIADB_VER:0:4}" = "10.1" && echo 'libressl-dev' || echo 'openssl-dev') \
        linux-headers \
        ncurses-dev \
        patch \
        readline-dev \
        zlib-dev; \
    \
    mariadb_url="https://downloads.mariadb.com/MariaDB/mariadb-${MARIADB_VER}/source/mariadb-${MARIADB_VER}.tar.gz"; \
    curl -fSL "${mariadb_url}" -o /tmp/mariadb.tar.gz; \
    curl -fSL "${mariadb_url}.asc" -o /tmp/mariadb.tar.gz.asc; \
    GPG_KEYS="199369E5404BD5FC7D2FE43BCBCB082A1BB943DB;430BDF5C56E7C94E848EE60C1C4CBDCDCD2EFD2A;4D1BB29D63D98E422B2113B19334A25F8507EFA5" gpg_verify /tmp/mariadb.tar.gz.asc /tmp/mariadb.tar.gz; \
    \
    tar zxf /tmp/mariadb.tar.gz -C /tmp; \
    cd "/tmp/mariadb-${MARIADB_VER}"; \
    # From alpine repository https://git.alpinelinux.org/cgit/aports/tree/main/mariadb?h=3.6-stable
    for i in /tmp/patches/"${MARIADB_VER:0:4}"/*.patch; do patch -p1 -i "${i}"; done; \
    \
    cmake . -DBUILD_CONFIG=mysql_release \
    		-DCMAKE_INSTALL_PREFIX=/usr \
    		-DSYSCONFDIR=/etc/mysql \
    		-DMYSQL_DATADIR=/var/lib/mysql \
    		-DMYSQL_UNIX_ADDR=/run/mysqld/mysqld.sock \
    		-DDEFAULT_CHARSET=utf8 \
    		-DDEFAULT_COLLATION=utf8_general_ci \
    		-DENABLED_LOCAL_INFILE=ON \
    		-DINSTALL_INFODIR=share/mysql/docs \
    		-DINSTALL_MANDIR=share/man \
    		-DINSTALL_PLUGINDIR=lib/mysql/plugin \
    		-DINSTALL_SCRIPTDIR=bin \
    		-DINSTALL_INCLUDEDIR=include/mysql \
    		-DINSTALL_DOCREADMEDIR=share/mysql \
    		-DINSTALL_SUPPORTFILESDIR=share/mysql \
    		-DINSTALL_MYSQLSHAREDIR=share/mysql \
    		-DINSTALL_DOCDIR=share/mysql/docs \
    		-DINSTALL_SHAREDIR=share/mysql \
    		-DWITH_READLINE=ON \
    		-DWITH_ZLIB=system \
    		-DWITH_SSL=system \
    		-DWITH_LIBWRAP=OFF \
    		-DWITH_JEMALLOC=no \
    		-DWITH_EXTRA_CHARSETS=complex \
    		-DWITH_EMBEDDED_SERVER=ON \
    		-DWITH_ARCHIVE_STORAGE_ENGINE=1 \
    		-DWITH_BLACKHOLE_STORAGE_ENGINE=1 \
    		-DWITH_INNOBASE_STORAGE_ENGINE=1 \
    		-DWITH_PARTITION_STORAGE_ENGINE=1 \
    		-DPLUGIN_TOKUDB=NO \
    		-DWITHOUT_EXAMPLE_STORAGE_ENGINE=1 \
    		-DWITHOUT_FEDERATED_STORAGE_ENGINE=1 \
    		-DWITHOUT_PBXT_STORAGE_ENGINE=1; \
    \
    make -j "$(nproc)"; \
    make install; \
    \
    # Script to fix volumes permissions via sudo.
    echo "chown mysql:mysql /var/lib/mysql ${BACKUPS_DIR}" > /usr/local/bin/init_volumes; \
    chmod +x /usr/local/bin/init_volumes; \
    echo 'mysql ALL=(root) NOPASSWD: /usr/local/bin/init_volumes' > /etc/sudoers.d/mysql; \
    \
    mkdir -p \
        /var/run/mysqld \
        /var/lib/mysql \
        /etc/mysql \
        /docker-entrypoint-initdb.d \
        "${BACKUPS_DIR}"; \
    \
    chown -R mysql:mysql \
        /var/run/mysqld \
        /var/lib/mysql \
        /usr/lib/mysql/plugin \
        /etc/mysql \
        /docker-entrypoint-initdb.d \
        "${BACKUPS_DIR}"; \
    \
    # Remove dev, test, doc, benchmark related files.
    rm -rf \
        /usr/bin/mysql_client_test \
        /usr/bin/mysql_client_test_embedded \
        /usr/bin/mysql_config \
        /usr/bin/mysqltest \
        /usr/bin/mysqltest_embedded \
        /usr/include/mysql \
        /usr/lib/libmariadb.so* \
        /usr/lib/libmariadbd.so.* \
        /usr/lib/libmysqlclient.so* \
        /usr/lib/libmysqlclient_r.so* \
        /usr/lib/libmysqld.so.* \
        /usr/mysql-test \
        /usr/share/man \
        /usr/sql-bench; \
    \
    find /usr/lib -name '*.a' -maxdepth 1 -print0 | xargs -0 rm; \
    find /usr/lib -name '*.so' -type l -maxdepth 1 -print0 | xargs -0 rm; \
    \
    # Stripping binaries and .so files.
    scanelf --symlink --recursive --nobanner --osabi --etype "ET_DYN,ET_EXEC" \
        /usr/bin/* /usr/lib/mysql/plugin/* | while read type osabi filename; do \
        ([ "$osabi" != "STANDALONE" ] && [ "${filename}" != "/usr/bin/strip" ]) || continue; \
        XATTR=$(getfattr --match="" --dump "${filename}"); \
        strip "${filename}"; \
        if [ -n "$XATTR" ]; then \
            echo "$XATTR" | setfattr --restore=-; \
        fi; \
    done; \
    \
    # Clean up.
    apk del --purge .mariadb-build-deps; \
    rm -rf /tmp/*; \
    rm -rf /var/cache/apk/*

USER mysql

COPY bin /usr/local/bin
COPY templates /etc/gotpl/
COPY docker-entrypoint.sh /

WORKDIR /var/lib/mysql
VOLUME /var/lib/mysql

EXPOSE 3306

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["mysqld"]
