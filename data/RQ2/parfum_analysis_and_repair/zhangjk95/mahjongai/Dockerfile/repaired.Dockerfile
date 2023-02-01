FROM mono:6.12.0
RUN curl -f -sL https://deb.nodesource.com/setup_11.x | bash - \
    && apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
COPY . /usr/src/app
RUN cd /usr/src/app/MajsoulHelper && npm install && npm cache clean --force;
RUN cd /usr/src/app && nuget restore MahjongAI.sln && msbuild MahjongAI.sln /t:Build /p:Configuration=Release
CMD cd /usr/src/app/MahjongAI/bin/Release && mono ./MahjongAI.exe | grep -v Information
