FROM desertbit/gml:windows
MAINTAINER team@desertbit.com

ENV CROSS_TRIPLE="i686-w64-mingw32.shared" \
    GOOS=windows \
    GOARCH=386

#import common/windows
#import common/windows_shared