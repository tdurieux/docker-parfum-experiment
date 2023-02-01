FROM guessi/docker-yourls:1.9.1

# security enhancement: leave only production required items
RUN rm -rf .git pages admin js css images sample* *.md                        \
           user/languages                                                     \
           user/plugins/random-bg                                             \
           yourls-api.php                                                     \
           yourls-infos.php                                                && \
    sed -i '/base64/d' yourls-loader.php                                   && \
    (find . -type f -name "*.html" ! -name "index.html" -delete)           && \
    (find . -type f -name "*.json" -o -name "*.md" -o -name "*.css" | xargs rm -f) && \
    (find . -type f -exec file {} + | awk -F: '{if ($2 ~/image/) print $1}' | xargs rm -f)