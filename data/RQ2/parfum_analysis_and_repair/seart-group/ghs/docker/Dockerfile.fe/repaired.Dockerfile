FROM nginx

COPY src/main/fe-src /usr/share/nginx/html

EXPOSE 3030

COPY docker/fe-entrypoint.sh /
RUN chmod 777 /fe-entrypoint.sh

ENTRYPOINT ["/fe-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]