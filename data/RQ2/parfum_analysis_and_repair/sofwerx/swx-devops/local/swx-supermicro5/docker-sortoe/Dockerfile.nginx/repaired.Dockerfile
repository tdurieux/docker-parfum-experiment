FROM 212171213234.dkr.ecr.us-east-1.amazonaws.com/sortoe/nginx:0.3.0

COPY sortoe-nginx.conf /etc/nginx/conf.d/sortoe.conf