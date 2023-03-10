FROM python:2.7.14 as collectstatic

ADD webapp/requirements.txt /tmp
RUN pip install --no-cache-dir -r /tmp/requirements.txt
ADD ./webapp /code
RUN /code/manage.py collectstatic --noinput

# multistage builds are awesomeeee
# https://docs.docker.com/engine/userguide/eng-image/multistage-build/#use-multi-stage-builds
FROM stantonk/nginx-ldap:1.0.1

# for envsubst
RUN apt-get update && apt-get install --no-install-recommends -y gettext && rm -rf /var/lib/apt/lists/*;

# from https://raw.githubusercontent.com/nginx/nginx/master/conf/uwsgi_params
ADD uwsgi_params /etc/nginx/uwsgi_params
ADD ./etc/nginx/nginx.conf.template /etc/nginx/nginx.conf.template

COPY --from=collectstatic /code/botanist-static /data/static

# enumrate env vars we allow envsubst to operate on so nginx variables
# such as $host and $request_uri don't get replaced :)
CMD /bin/bash -c "envsubst '\$NGINX_HOST \$NGINX_PORT \$LDAP_URL \$LDAP_BIND_DN \$LDAP_BIND_DN_PASSWD \$LDAP_GROUP_ATTRIBUTE \$LDAP_GROUP_ATTRIBUTE_IS_DN \$LDAP_REQUIRE_GROUP'< /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf && dockerize -stdout /var/log/nginx/access.log -stderr /var/log/nginx/error.log /usr/sbin/nginx -g 'daemon off;'"
