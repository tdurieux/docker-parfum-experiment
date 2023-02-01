# or v0.12-debian-onbuild
FROM fluent/fluentd:v1.3-debian-onbuild

# below RUN includes plugin as examples elasticsearch is not required
# you may customize including plugins as you wish

# 更新apt-get源