FROM mysql:8
CMD [ "--default-authentication-plugin=mysql_native_password", "--collation-server=utf8_general_ci", "--character-set-server=utf8" ]