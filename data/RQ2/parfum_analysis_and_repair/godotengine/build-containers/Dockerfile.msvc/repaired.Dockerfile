ARG img_version
FROM godot-fedora:${img_version}

ENV WINEDEBUG=-all

RUN dnf -y install --setopt=install_weak_deps=False \
      wine winetricks xorg-x11-server-Xvfb p7zip-plugins findutils && \
    curl -f -LO https://github.com/GodotBuilder/godot-builds/releases/download/_tools/angle.7z && \
    curl -f -LO https://www.python.org/ftp/python/3.7.2/python-3.7.2-amd64.exe && \
    xvfb-run sh -c "winetricks -q vcrun2017; wineserver -w"; \
    xvfb-run sh -c "winetricks -q dotnet461; wineserver -w" ; \
    xvfb-run sh -c "wine /root/python-3.7.2-amd64.exe /quiet InstallAllUsers=1 PrependPath=1 Include_test=0; wineserver -w" ; \
    rm /root/python-3.7.2-amd64.exe && \
    wine python -m pip install --upgrade pip ; wineserver -w ; \
    wine pip install -U setuptools ; wineserver -w ; \
    wine pip install -U wheel ; wineserver -w ; \
    wine pip install scons pywin32 ; wineserver -w ; \
    cd /root/.wine/drive_c && \
    7z x /root/angle.7z && \
    rm /root/angle.7z && \
    cd "/root/.wine/drive_c/Program Files (x86)" && \
    tar xf /root/files/msvc2017.tar && \
    cd /root && \
    bash /root/files/msvc-fixup.sh && \
    find /root/.wine -name vctip.exe -delete && \
    rm -rf /root/.wine/drive_c/users/root/Temp/* && \
    rm -rf /root/.cache && rm /root/files/msvc2017.tar

CMD /bin/bash
