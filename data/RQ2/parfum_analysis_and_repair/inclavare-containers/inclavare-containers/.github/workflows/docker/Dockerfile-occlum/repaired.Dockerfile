FROM scratch

ADD occlum_instance.tar.gz /
ENTRYPOINT ["/bin/hello_world"]