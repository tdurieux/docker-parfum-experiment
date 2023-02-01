# Based on .exmples/dockerfiles/smtp/fpm
FROM friendica:fpm

# simple = using an smtp without any credentials (mostly in local networks)
# custom = you need to set host, port, auth_options, authinfo (e.g. for GMX support)