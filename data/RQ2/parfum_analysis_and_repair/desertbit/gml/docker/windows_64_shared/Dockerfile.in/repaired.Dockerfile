FROM desertbit/gml:windows
MAINTAINER team@desertbit.com

ENV CROSS_TRIPLE="x86_64-w64-mingw32.shared" \
    GOOS=windows \
    GOARCH=amd64

#import common/windows
#import common/windows_shared