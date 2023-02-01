############################################################
## Dockerfile to build kateway container images
#
# to run it:
# 0. curl -sSL https://get.docker.com/ | sh; service docker start
# 1. docker build -t "kateway:latest" .
# 2. docker run -d --name kateway -p 10191:9191 -p 10192:9192 -p 10193:9193 kateway:latest /go/bin/kateway -z prod -id 1 -log kateway.log -crashlog panic -influxdbaddr http://10.213.1.223:8086
#############################################################