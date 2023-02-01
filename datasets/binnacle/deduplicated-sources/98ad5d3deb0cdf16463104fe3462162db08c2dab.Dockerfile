# Docker file for JuliaBox Engine providing interactive sessions
# Version:1

FROM juliabox/enginebase

MAINTAINER Tanmay Mohapatra

# Expose the HTTP port
# For proxying to work efficiently, it may be best to run the container on host network stack
EXPOSE 8888

ADD www /jboxengine/www
# Allow juser write permissions on admin_modules.tpl and auth_modules.tpl to generate its content at run time.
RUN chmod 666 /jboxengine/www/admin_modules.tpl /jboxengine/www/auth_modules.tpl /jboxengine/www/session_modules.tpl

USER juser
ENV LANG en_US.utf8

ENTRYPOINT ["/jboxengine/src/jbox.py"]