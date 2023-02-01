FROM busybox
ADD www-dist/ /www/
ADD svg-placeholder /app/svg-placeholder
ENV PORT 5000
EXPOSE 5000
ENTRYPOINT ["/app/svg-placeholder"]
