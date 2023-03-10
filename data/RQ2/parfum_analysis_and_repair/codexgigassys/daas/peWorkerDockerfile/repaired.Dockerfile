FROM python:3.7.4-stretch
RUN mkdir /daas
WORKDIR /daas
ENV HOME /home/root
COPY requirements_worker.txt /tmp/requirements_worker.txt
RUN pip install --no-cache-dir --upgrade pip && \
    pip --retries 10 --no-cache-dir install -r /tmp/requirements_worker.txt


# C#: Set wine to use x86 instead of x64
ENV WINEARCH win32


# Generic
RUN apt-get update && \
    apt-get install --no-install-recommends -y build-essential apt-transport-https && \
    apt-get install --no-install-recommends -y gnutls-bin \
        host \
        unzip \
        xauth \
        xvfb \
        zenity \
        zlib1g \
        zlib1g-dev \
        zlibc && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean


# C#: Wine and wine's utils.
RUN dpkg --add-architecture i386 && \
    apt-get update && \
    wget -nc https://dl.winehq.org/wine-builds/winehq.key && \
    apt-key add winehq.key && \
    echo "deb https://dl.winehq.org/wine-builds/debian/ stretch main" >> /etc/apt/sources.list.d/wine.list && \
    apt-get update && \
    apt install -y --no-install-recommends --assume-yes --allow-unauthenticated winehq-devel:i386=4.19~stretch \
    wine-devel:i386=4.19~stretch \
    wine-devel-i386:i386=4.19~stretch \
    fonts-wine \
    cabextract && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean


# C#: Winetricks, dotnet45, vcrun2010
RUN echo "Installing winetricks" && \
    wget -nc -nv https://github.com/Winetricks/winetricks/archive/20210825.zip -O /tmp/winetricks.zip && \
    unzip /tmp/winetricks.zip -d /tmp/winetricks/ && \
    make -C /tmp/winetricks/winetricks-20210825 install && \
    rm -rf /tmp/winetricks.zip && \
    rm -rf /tmp/winetricks && \
    echo "Winetricks installed"
# Dotnet45 should be installed on a different docker step. Otherwise, it will fail.
RUN echo "Installing Dotnet45" && \
    winetricks -q dotnet45 corefonts && \
    echo "Dotnet45 installed"
RUN xvfb-run winetricks -q vcrun2010 && \
    echo "vcrun2010 installed"
