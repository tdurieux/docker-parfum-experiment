FROM therecipe/qt:wine_base as base

ENV QT qt-opensource-windows-x86-mingw492-5.6.3.exe
RUN curl -f -sL --retry 10 --retry-delay 60 -O https://download.qt.io/new_archive/qt/5.6/5.6.3/$QT
RUN QT_QPA_PLATFORM=minimal xvfb-run wine Z:\\$QT --no-force-installations --script=C:\\gopath\\src\\github.com\\therecipe\\qt\\internal\\ci\\iscript.qs WINDOWS=true VERSION=563 && rm -f $QT
RUN rm -f $(find $HOME/.wine/drive_c/Qt/Qt5.6.3/5.6.3/mingw49_32 -name "*d.a" -exec grep -l "gnu_debug" {} \+)
RUN rm -f $(find $HOME/.wine/drive_c/Qt/Qt5.6.3/5.6.3/mingw49_32 -name "*d.dll" -exec grep -l "gnu_debug" {} \+)
RUN rm -f $(find $HOME/.wine/drive_c/Qt/Qt5.6.3/5.6.3/mingw49_32 -name "*d.dll.a" -exec grep -l "gnu_debug" {} \+)
RUN find $HOME/.wine/drive_c/Qt/Qt5.6.3/5.6.3/mingw49_32 -name "*.exe" -size +7M -maxdepth 4 -delete
RUN find $HOME/.wine/drive_c/Qt/Qt5.6.3/Docs -type f ! -name "*.index" -delete


FROM ubuntu:16.04
LABEL maintainer therecipe

ENV USER user
ENV HOME /home/$USER
ENV GOPATH C:\\gopath
ENV WINEDEBUG -all
ENV WINEPATH C:\\go\\bin

COPY --from=base $HOME/.wine/drive_c/go $HOME/.wine/drive_c/go
COPY --from=base $HOME/.wine/drive_c/gopath/bin $HOME/.wine/drive_c/gopath/bin
COPY --from=base $HOME/.wine/drive_c/gopath/src/github.com/therecipe/qt $HOME/.wine/drive_c/gopath/src/github.com/therecipe/qt
COPY --from=base $HOME/.wine/drive_c/Qt/Qt5.6.3/5.6.3/mingw49_32 $HOME/.wine/drive_c/Qt/Qt5.6.3/5.6.3/mingw49_32
COPY --from=base $HOME/.wine/drive_c/Qt/Qt5.6.3/Docs $HOME/.wine/drive_c/Qt/Qt5.6.3/Docs
COPY --from=base $HOME/.wine/drive_c/Qt/Qt5.6.3/Tools/mingw492_32 $HOME/.wine/drive_c/Qt/Qt5.6.3/Tools/mingw492_32

RUN apt-get -qq update && apt-get --no-install-recommends -qq -y install ca-certificates curl software-properties-common apt-transport-https && apt-get -qq clean && rm -rf /var/lib/apt/lists/*;
RUN dpkg --add-architecture i386
RUN curl -f -sL --retry 10 --retry-delay 60 https://dl.winehq.org/wine-builds/winehq.key | apt-key add -
RUN apt-add-repository https://dl.winehq.org/wine-builds/ubuntu/
RUN apt-add-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ xenial main'
RUN apt-get -qq update && apt-get --no-install-recommends -qq -y install winehq-stable && apt-get -qq clean && rm -rf /var/lib/apt/lists/*;
RUN WINEDLLOVERRIDES="mscoree,mshtml=" wineboot && wineserver -w

RUN echo 'REGEDIT4\n\n\
[HKEY_CURRENT_USER\Environment]\n\
"QT_DOCKER"="true"\n\
"QT_VERSION"="5.6.3"' > env.reg && regedit Z:\\env.reg && wineserver -w && rm -f env.reg

RUN wine $GOPATH\\bin\\qtsetup prep
RUN wine $GOPATH\\bin\\qtsetup check
RUN wine $GOPATH\\bin\\qtsetup generate
RUN cd $HOME/.wine/drive_c/gopath/src/github.com/therecipe/qt/internal/examples/widgets/line_edits && sed -i -e 's/AddWidget2/AddWidget/g' line_edits.go && wine qtdeploy build && rm -rf ./deploy

RUN echo "#!/bin/bash\nexport GOPATH=\$(winepath -0 -w \$(echo \$GOPATH | sed -e 's/:/ /g') | sed -e 's/Z:/;Z:/2g')" > /usr/bin/qtpath && chmod +x /usr/bin/qtpath
RUN echo '#!/bin/bash\nsource qtpath\nwine qtdeploy "$@"' > /usr/bin/qtdeploy && chmod +x /usr/bin/qtdeploy
RUN echo '#!/bin/bash\nsource qtpath\nwine qtminimal "$@"' > /usr/bin/qtminimal && chmod +x /usr/bin/qtminimal
RUN echo '#!/bin/bash\nsource qtpath\nwine qtmoc "$@"' > /usr/bin/qtmoc && chmod +x /usr/bin/qtmoc
RUN echo '#!/bin/bash\nsource qtpath\nwine qtrcc "$@"' > /usr/bin/qtrcc && chmod +x /usr/bin/qtrcc
RUN ln -s $HOME/.wine/drive_c/gopath $HOME/work
