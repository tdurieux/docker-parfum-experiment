FROM onlyoffice/communityserver:latest AS communityserver-ami
ARG APPSETTING_CONFIG=/var/www/onlyoffice/WebStudio/web.appsettings.config
ARG RESOURCE_SQL=/var/www/onlyoffice/Sql/onlyoffice.resources.sql

RUN apt-get -y update && \
   apt-get install --no-install-recommends -yq xmlstarlet && rm -rf /var/lib/apt/lists/*;

RUN echo "INSERT INTO \`tenants_tariff\` (\`tenant\`, \`tariff\`, \`stamp\`, \`comment\`) VALUES ('-1', '-1000', NOW() + INTERVAL 5 YEAR, 'ami');" >> $RESOURCE_SQL && \
    echo "INSERT INTO \`tenants_quota\` (\`tenant\`, \`name\`, \`max_file_size\`, \`max_total_size\`, \`active_users\`, \`features\`) VALUES ('-1000', 'start_trial', '102400', '10995116277760', '10000', 'docs,domain,audit,controlpanel,healthcheck,ldap,sso,whitelabel,branding,ssbranding,update,support,portals:10000,discencryption,privacyroom');" >> $RESOURCE_SQL && \
    echo "UPDATE \`core_settings\` SET \`value\` = 0x1371A72766B7FD0D86DC0E83CFFFF0CE9A8BE350B7D1779D12C2D160376CFDE646294E0DE9B8E487DC856817EF01A21F53C93883F979FCE38AFE74799B58B64E822FFAD96289813A644CC5CBE2471328E5B9D03DB4426D67EC877299ABD6A5BE6561F4A8061ECE01D41F50220EFB748AC1F67E5D649E57E204352DC2DFF15E18675A9AA5BAAD41CC4779CBE63C5933E1 WHERE tenant = -1 AND id = 'SmtpSettings';" >> $RESOURCE_SQL && \
    chown onlyoffice:onlyoffice $RESOURCE_SQL

RUN xmlstarlet ed -L \
    -s "/appSettings" -t elem -n "add" \
    -i "/appSettings/add[not(@*)]" -t attr -n "key" -v "fullTextSearch" \
    -i "/appSettings/add[@key='fullTextSearch']" -t attr -n "value" -v "false" \
    $APPSETTING_CONFIG && \
    xmlstarlet ed -L \
    -s "/appSettings" -t elem -n "add" \
    -i "/appSettings/add[not(@*)]" -t attr -n "key" -v "web.ami.meta" \
    -i "/appSettings/add[@key='web.ami.meta']" -t attr -n "value" -v "http://169.254.169.254/latest/meta-data/" \
    $APPSETTING_CONFIG && \
    xmlstarlet ed -L \
    -d "/appSettings/add[@key='files.thirdparty.enable']" \
    -s "/appSettings" -t elem -n "add" \
    -i "/appSettings/add[not(@*)]" -t attr -n "key" -v "files.thirdparty.enable" \
    -i "/appSettings/add[@key='files.thirdparty.enable']" -t attr -n "value" -v "box,dropboxv2,docusign,google,onedrive,nextcloud,owncloud,webdav,kdrive,yandex" \
    $APPSETTING_CONFIG && \
    xmlstarlet ed -L \
    -d "/appSettings/add[@key='web.hide-settings']" \
    -s "/appSettings" -t elem -n "add" \
    -i "/appSettings/add[not(@*)]" -t attr -n "key" -v "web.hide-settings" \
    -i "/appSettings/add[@key='web.hide-settings']" -t attr -n "value" -v "VersionSettings,Monitoring,PublicPortal,PortalRename,Migration,Promocode,TariffSettings,ProxyHttpContent,MailService,FullTextSearch,Storage,EncryptionSettings" \
    $APPSETTING_CONFIG

FROM communityserver-ami AS communityserver-alc
ARG APPSETTING_CONFIG=/var/www/onlyoffice/WebStudio/web.appsettings.config

RUN xmlstarlet ed -L \
    -d "/appSettings/add[@key='web.ami.meta']" \
    -s "/appSettings" -t elem -n "add" \
    -i "/appSettings/add[not(@*)]" -t attr -n "key" -v "web.ami.meta" \
    -i "/appSettings/add[@key='web.ami.meta']" -t attr -n "value" -v "http://100.100.100.200/latest/meta-data/" \
    $APPSETTING_CONFIG
