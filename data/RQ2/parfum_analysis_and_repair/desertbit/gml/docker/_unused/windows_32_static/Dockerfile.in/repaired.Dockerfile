FROM desertbit/gml:windows
MAINTAINER team@desertbit.com

ENV CROSS_TRIPLE="i686-w64-mingw32.static" \
    GOOS=windows \
    GOARCH=386

#import common/windows