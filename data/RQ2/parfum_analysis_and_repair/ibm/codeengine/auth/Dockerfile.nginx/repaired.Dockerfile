FROM icr.io/codeengine/nginx

# call-ngninx is just a script that'll replace "NS" in the config file with
# the proper project ID
COPY call-nginx /

# htpasswd contains the user/password info - for auth
COPY htpasswd /etc/apache2/.htpasswd

# Use our custom nginx config file
COPY nginx.conf /etc/nginx/conf.d/default.conf

# At runtime, call the wrapper script to do the "NS" substitutions
CMD ["/call-nginx"]