FROM 212171213234.dkr.ecr.us-east-1.amazonaws.com/sortoe/sortoe-web:1.0.3

COPY sortoe-web.conf /etc/nginx/conf.d/sortoe.conf

COPY run-web.sh /run-web.sh

CMD /run-web.sh