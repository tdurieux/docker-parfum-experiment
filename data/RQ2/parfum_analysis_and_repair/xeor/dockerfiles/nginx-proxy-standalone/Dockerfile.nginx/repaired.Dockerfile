inotify-tools
while inotifywait -e close_write /usr/local/nginx/conf/generated.conf; do echo "changed"; done