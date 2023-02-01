# docker build -f Dockerfile2 -t kiki2 .
# docker run --user `id -u` --rm -it --expose 8003 -p 8003:8003 -p 8004:8004 -v `pwd`/data:/data -t kiki2