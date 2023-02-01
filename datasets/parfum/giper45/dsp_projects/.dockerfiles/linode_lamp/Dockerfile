FROM linode/lamp

RUN apt-get update && apt-get install -y php5-mysql php5-gd python vsftpd xinetd ftp wget
RUN rm -rf /var/www/example/example.com && rm /etc/apache2/sites-available/* && rm /etc/apache2/sites-enabled/* 

COPY setgw.sh /setgw.sh
COPY mysql_start.sh /mysql_start.sh
COPY apache_start.sh /apache_start.sh
COPY apache_start_debug.sh /apache_start_debug.sh
COPY create_db.sh /create_db.sh
COPY exec.sh /exec.sh
COPY sed.sh /sed.sh
COPY sql_to_db.sh /sql_to_db.sh
COPY allow_url_include.sh /allow_url_include.sh
COPY set_listening_port.sh /set_listening_port.sh
COPY set_logs_readable.sh /set_logs_readable.sh
COPY mysql_remote_access.sh /mysql_remote_access.sh
COPY mysql_set_root_user.sh /mysql_set_root_user.sh
COPY ftp_start.sh /ftp_start.sh
COPY ftp_stop.sh /ftp_stop.sh
COPY adduser.sh /adduser.sh
COPY addctf.sh /addctf.sh
COPY addrootctf.sh /addrootctf.sh

COPY vsftpd /etc/xinetd.d/vsftpd
COPY vsftpd.conf /etc/vsftpd.conf
# COPY pure-ftpd_1.0.36-1.1ubuntu0.1_amd64.deb /pure-ftpd_1.0.36-1.1ubuntu0.1_amd64.deb

# RUN dpkg -i /pure-ftpd_1.0.36-1.1ubuntu0.1_amd64.deb

LABEL \
      type="server" \ caps_add="NET_ADMIN" \ 
      actions.sed.command="/sed.sh " \ 
      actions.sed.description="Replace a string with another inside a file" \ actions.sed.args.filename.val="" \
      actions.sed.args.filename.type="text" \
      actions.sed.args.string_one.val="" \
      actions.sed.args.string_one.type="text" \
      actions.sed.args.string_two.val="" \
      actions.sed.args.string_two.type="text" \

      actions.adduser.command="/adduser.sh" \ 
      actions.adduser.description="Add a new username : <name> <password> " \ 
      actions.adduser.args.name.val="user" \
      actions.adduser.args.name.type="text" \
      actions.adduser.args.name.rule.pattern="^[a-zA-Z0-9_-]+$" \
      actions.adduser.args.password.val="password" \
      actions.adduser.args.password.type="text" \
      actions.adduser.args.password.rule.pattern="^[a-zA-Z0-9_-]+$" \

      actions.exec.command="/exec.sh " \ 
      actions.exec.description="Execute a command in the container" \ 
      actions.exec.args.command.val="mkdir hello" \
      actions.exec.args.command.type="text" \

      actions.start_apache.command="/apache_start.sh" \ 
      actions.start_apache.description="Start web server" \ 

      actions.start_apache_debug.command="/apache_start_debug.sh" \ 
      actions.start_apache_debug.description="Start web server in debug mode (all errors reported)" \ 

      actions.start_mysql.command="/mysql_start.sh" \ 
      actions.start_mysql.description="Start sql server" \ 


      actions.create_db.command="/create_db.sh" \ 
      actions.create_db.description="Create a new db, insert a name for new db" \ 
      actions.create_db.args.db_name.rule.pattern="^[a-zA-Z0-9_-]+$" \ 
      actions.create_db.args.db_name.val="" \ 
      actions.create_db.args.db_name.type="text" \ 

      actions.sql_to_db.command="/sql_to_db.sh" \ 
      actions.sql_to_db.description="Execute a sql file into a db (you must load a sql file in container first! ) " \ 
      actions.sql_to_db.args.db_name.val="" \ 
      actions.sql_to_db.args.db_name.type="text" \ 
      actions.sql_to_db.args.sql_file.val="" \ 
      actions.sql_to_db.args.sql_file.type="text" \ 

      actions.setgw.command="/setgw.sh" \ 
      actions.setgw.description="Set default gateway  <name container gateway> " \ 
      actions.setgw.args.gateway.val="" \
      actions.setgw.args.gateway.type="text" \
      actions.setgw.args.gateway.rule.pattern="^[a-zA-Z0-9_-]+$" \

      actions.allow_url_include.command="/allow_url_include.sh" \ 
      actions.allow_url_include.description="Set allow url include to On" \ 

      actions.set_logs_readable.command="/set_logs_readable.sh" \ 
      actions.set_logs_readable.description="Set Readable Logs" \ 

      actions.mysql_remote_access.command="/mysql_remote_access.sh" \ 
      actions.mysql_remote_access.description="Enable mysql remote access" \ 

      actions.mysql_set_root_user.command="/mysql_set_root_user.sh" \ 
      actions.mysql_set_root_user.description="Set root user " \ 

      actions.set_listening_port.command="/set_listening_port.sh " \ 
      actions.set_listening_port.description="Set Listening Port" \ 
      actions.set_listening_port.args.listening_port.val="80" \
      actions.set_listening_port.args.listening_port.type="text" \

      actions.ftp_start.command="/ftp_start.sh" \ 
      actions.ftp_start.description="Start ftp service" \ 

      actions.ftp_stop.command="/ftp_stop.sh" \ 
      actions.ftp_stop.description="Stop ftp service" \ 

      actions.addctf.command="/addctf.sh" \ 
      actions.addctf.description="Add a ctf in /home/<username> directory inside a secret file" \ 
      actions.addctf.args.username.val="" \
      actions.addctf.args.username.type="text" \
      actions.addctf.args.username.rule.pattern="^[a-zA-Z0-9_-]+$" \
      actions.addctf.args.ctf.val="" \
      actions.addctf.args.ctf.type="text" \

      actions.addrootctf.command="/addrootctf.sh" \ 
      actions.addrootctf.description="Add a ctf in /root directory inside a secret file" \ 
      actions.addrootctf.args.ctf.val="" \
      actions.addrootctf.args.ctf.type="text" \
