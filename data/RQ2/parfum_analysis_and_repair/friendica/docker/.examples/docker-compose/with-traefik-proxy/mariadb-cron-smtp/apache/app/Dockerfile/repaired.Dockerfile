# Based on .exmples/dockerfiles/smtp/apache
FROM friendica:apache

# simple = using an smtp without any credentials (mostly in local networks)
# custom = you need to set host, port, auth_options, authinfo (e.g. for GMX support)