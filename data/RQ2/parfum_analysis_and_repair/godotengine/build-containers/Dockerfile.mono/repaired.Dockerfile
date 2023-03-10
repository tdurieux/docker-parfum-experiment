ARG img_version
FROM godot-fedora:${img_version}

ARG mono_version

RUN if [ -z "${mono_version}" ]; then echo -e "\n\nargument mono-version is mandatory!\n\n"; exit 1; fi && \
    dnf -y install --setopt=install_weak_deps=False \
      autoconf automake cmake gcc gcc-c++ gettext libtool perl python-unversioned-command && \
    cp -a /root/files/${mono_version} /root && \
    cd /root/${mono_version} && \
    NOCONFIGURE=1 ./autogen.sh && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr --sysconfdir=/etc --localstatedir=/var/lib/mono --disable-boehm --host=x86_64-linux-gnu && \
    make -j && \
    make install && \
    cd /root && \
    rm -rf /root/${mono_version} && \
    cert-sync /etc/pki/tls/certs/ca-bundle.crt && \
    rpm -ivh --nodeps \
      https://download.mono-project.com/repo/centos8-preview/m/msbuild/msbuild-16.10.1+xamarinxplat.2021.05.26.14.00-0.xamarin.7.epel8.noarch.rpm \
      https://download.mono-project.com/repo/centos8-preview/m/msbuild/msbuild-sdkresolver-16.10.1+xamarinxplat.2021.05.26.14.00-0.xamarin.7.epel8.noarch.rpm \
      https://download.mono-project.com/repo/centos8-preview/m/msbuild-libhostfxr/msbuild-libhostfxr-3.0.0.2019.04.16.02.13-0.xamarin.4.epel8.x86_64.rpm \
      https://download.mono-project.com/repo/centos8-preview/n/nuget/nuget-5.6.0.6489.bin-0.xamarin.1.epel8.noarch.rpm

CMD /bin/bash
