# docker build -t transmission-rss .
# docker build -t transmission-rss --build-arg UID=1337 --build-arg GID=1337 .
# docker run -it -v $(pwd)/transmission-rss.conf:/etc/transmission-rss.conf transmission-rss