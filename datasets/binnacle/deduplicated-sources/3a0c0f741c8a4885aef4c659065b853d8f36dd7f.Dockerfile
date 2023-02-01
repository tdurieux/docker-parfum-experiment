FROM aqzt/docker-alpine
LABEL maintainer="aqzt.com (ppabc@qq.com)"

    ENV MARIADB_VER=10.2.14 \
        ZABBIX_HOSTNAME=mariadb-db \
        ENABLE_SMTP=FALSE

		### Install Required Dependencies
    RUN export CPU=`cat /proc/cpuinfo | grep -c processor` ; \
        
        # Add testing repo
        echo http://dl-4.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories ; \
        
        # Install packages
        apk add --no-cache \
            
            # Install utils
            libressl \
            pwgen \

            # Installing needed libs
            boost \
            geos \
            gnutls \
            ncurses-libs \
            libaio \
            libcurl \
            libstdc++ \
            libxml2 \
            proj4 \

            # Install MariaDB build deps
            alpine-sdk \
            bison \
            boost-dev \
            cmake \
            curl-dev \
            gnutls-dev \
            libaio-dev \
            libressl-dev \
            libxml2-dev \
            linux-headers \
            ncurses-dev \
            ; \

        # Add group and user for mysql
        addgroup -S -g 500 mysql ; \
        adduser -S -D -H -u 500 -G mysql -g "MySQL" mysql ; \
        
        # Download and unpack mariadb
        mkdir -p /etc/mysql ; \
        curl -sSL http://mariadb.mirror.iweb.com/mariadb-${MARIADB_VER}/source/mariadb-${MARIADB_VER}.tar.gz | tar xvfz - --strip=0 -C /usr/src/ ; \
        
        # Build maridb
        mkdir -p /tmp/_ ; \
        cd /usr/src/mariadb-${MARIADB_VER} ; \
        cmake . \
            -DCMAKE_BUILD_TYPE=MinSizeRel \
            -DCOMMON_C_FLAGS="-O3 -s -fno-omit-frame-pointer -pipe" \
            -DCOMMON_CXX_FLAGS="-O3 -s -fno-omit-frame-pointer -pipe" \
            -DCMAKE_INSTALL_PREFIX=/usr \
            -DSYSCONFDIR=/etc/mysql \
            -DMYSQL_DATADIR=/var/lib/mysql \
            -DMYSQL_UNIX_ADDR=/run/mysqld/mysqld.sock \
            -DDEFAULT_CHARSET=utf8 \
            -DDEFAULT_COLLATION=utf8_general_ci \
            -DENABLED_LOCAL_INFILE=ON \
            -DINSTALL_INFODIR=share/mysql/docs \
            -DINSTALL_MANDIR=/tmp/_/share/man \
            -DINSTALL_PLUGINDIR=lib/mysql/plugin \
            -DINSTALL_SCRIPTDIR=bin \
            # -DINSTALL_INCLUDEDIR=/tmp/_/include/mysql \
            -DINSTALL_DOCREADMEDIR=/tmp/_/share/mysql \
            -DINSTALL_SUPPORTFILESDIR=share/mysql \
            -DINSTALL_MYSQLSHAREDIR=share/mysql \
            -DINSTALL_DOCDIR=/tmp/_/share/mysql/docs \
            -DINSTALL_SHAREDIR=share/mysql \
            -DWITH_READLINE=ON \
            -DWITH_ZLIB=system \
            -DWITH_SSL=system \
            -DWITH_LIBWRAP=OFF \
            -DWITH_JEMALLOC=no \
            -DWITH_EXTRA_CHARSETS=complex \
            -DPLUGIN_ARCHIVE=STATIC \
            -DPLUGIN_BLACKHOLE=DYNAMIC \
            -DPLUGIN_INNOBASE=STATIC \
            -DPLUGIN_PARTITION=AUTO \
            -DPLUGIN_CONNECT=NO \
            -DPLUGIN_TOKUDB=NO \
            -DPLUGIN_FEEDBACK=NO \
            -DPLUGIN_OQGRAPH=NO \
            -DPLUGIN_FEDERATED=NO \
            -DPLUGIN_FEDERATEDX=NO \
            -DWITHOUT_FEDERATED_STORAGE_ENGINE=1 \
            -DWITHOUT_EXAMPLE_STORAGE_ENGINE=1 \
            -DWITHOUT_PBXT_STORAGE_ENGINE=1 \
            -DWITHOUT_ROCKSDB_STORAGE_ENGINE=1 \
            -DWITH_EMBEDDED_SERVER=OFF \
            -DWITH_UNIT_TESTS=OFF \
            -DENABLED_PROFILING=OFF \
            -DENABLE_DEBUG_SYNC=OFF \
            ; \

        make -j${CPU} ; \
        
        # Install
        make -j${CPU} install ; \
        
        # Copy default config, and remove deprecates and not working things
        cp /usr/share/mysql/my-large.cnf /etc/mysql/my.cnf ; \
        echo "!includedir /etc/mysql/conf.d/" >>/etc/mysql/my.cnf &&\
        sed -i '/# Try number of CPU/d' /etc/mysql/my.cnf ; \
        sed -i '/thread_concurrency = 8/d' /etc/mysql/my.cnf ; \
        sed -i '/innodb_additional_mem_pool_size/d' /etc/mysql/my.cnf ; \
        sed -i 's/log-bin=/#log-bin=/' /etc/mysql/my.cnf ; \
        sed -i 's/binlog_format=/#binlog_format=/' /etc/mysql/my.cnf ; \
        sed -i 's/#innodb_/innodb_/' /etc/mysql/my.cnf ; \
        
        # Clean everything
        rm -rf /usr/src ; \
        rm -rf /tmp/_ ; \
        rm -rf /usr/sql-bench ; \
        rm -rf /usr/mysql-test ; \
        rm -rf /usr/data ; \
        rm -rf /usr/lib/python2.7 ; \
        rm -rf /usr/bin/mysql_client_test ; \
        rm -rf /usr/bin/mysqltest ; \
        
        # Remove packages
        apk del \
            alpine-sdk \
            bison \
            boost-dev \
            cmake \
            curl-dev \
            gnutls-dev \
            libaio-dev \
            libressl-dev \
            libxml2-dev \
            linux-headers \
            ncurses-dev \
            ; \
        
        # Create needed directories
        mkdir -p /var/lib/mysql ; \
        mkdir -p /run/mysqld ; \
        mkdir /etc/mysql/conf.d ; \
        
        # Set permissions
        chown -R mysql:mysql /var/lib/mysql ; \
        chown -R mysql:mysql /run/mysqld ; \
        chmod 777 /tmp ; \
        rm -rf /var/cache/apk/*


### Networking
   EXPOSE 3306
      ADD root /
