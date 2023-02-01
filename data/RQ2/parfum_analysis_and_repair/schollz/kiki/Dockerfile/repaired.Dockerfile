# docker build -f Dockerfile -t kiki .
# docker run --user `id -u` --rm -it -p 8003:8003 -v /tmp/data:/data -t kiki