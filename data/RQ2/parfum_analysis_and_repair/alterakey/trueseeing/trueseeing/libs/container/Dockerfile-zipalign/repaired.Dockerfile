from alpine as builder
add android-sdk-build-tools-33.0.0.tar.gz /

from alpine
run apk add --no-cache libgcc gcompat
run mkdir -p /app/lib64
copy --from=0 /sdk/build-tools/33.0.0/zipalign /app/
copy --from=0 /sdk/build-tools/33.0.0/lib64/libc++* /app/lib64/
run chmod 755 /app/zipalign
env PATH=/app:/usr/local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
workdir /out
entrypoint ["zipalign"]