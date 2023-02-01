FROM ubuntu:18.04

RUN useradd -m wagahigh

# なぜか ADD --chown が効かない……
ADD wagahigh.tar.xz /home/wagahigh/.wine/drive_c/wagahigh/
RUN chown -R wagahigh:wagahigh /home/wagahigh

# apt-get update がクソ遅いので日本サーバーに変更
RUN sed -i 's|//archive\.ubuntu\.com|//jp\.archive\.ubuntu\.com|g' /etc/apt/sources.list && \
    sed -i 's/^deb-src/# deb-src/g' /etc/apt/sources.list

# 必要なパッケージのインストール
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends wget apt-transport-https software-properties-common gpg-agent && rm -rf /var/lib/apt/lists/*;

# Wine のインストール
RUN dpkg --add-architecture i386 && \
    wget -qO - https://dl.winehq.org/wine-builds/Release.key | apt-key add - && \
    apt-add-repository -y https://dl.winehq.org/wine-builds/ubuntu/ && \
    apt-get install --no-install-recommends -y winehq-devel && rm -rf /var/lib/apt/lists/*;

# 日本的に
RUN apt-get install --no-install-recommends -y locales tzdata && \
    locale-gen ja_JP.UTF-8 && \
    echo 'Asia/Tokyo' > /etc/timezone && \
    rm /etc/localtime && \
    ln -s /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
    dpkg-reconfigure tzdata && rm -rf /var/lib/apt/lists/*;

# ツールのインストール
RUN apt-get install -y --no-install-recommends xvfb x11vnc xdotool && rm -rf /var/lib/apt/lists/*;

# パッケージリポジトリの winetricks は古いので直接ダウンロード
RUN apt-get install --no-install-recommends -y make && \
    wget -qO - https://github.com/Winetricks/winetricks/archive/20180815.tar.gz | tar -xzf - && \
    make -C winetricks-20180815 install && \
    rm -rf winetricks-20180815 && \
    apt-mark auto make && apt-get autoremove -y && rm -rf /var/lib/apt/lists/*;

# 各種環境変数
# WINEDLLOVERRIDES: Wine の初回起動時に Mono と Gecko を入れろダイアログを表示させない
# W_OPT_UNATTENDED: winetricks に GUI なしでインストールしてもらう
ENV LANG="ja_JP.UTF-8" \
    WINEARCH=win32 \
    WINEDLLOVERRIDES="mscoree=d;mshtml=d" \
    W_OPT_UNATTENDED=1

COPY run_wagahigh.sh /
RUN chmod a+rx /run_wagahigh.sh

WORKDIR /home/wagahigh
USER wagahigh

RUN winetricks wenquanyi

CMD /run_wagahigh.sh
