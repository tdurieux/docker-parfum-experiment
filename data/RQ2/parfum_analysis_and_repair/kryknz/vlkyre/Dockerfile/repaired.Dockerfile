# ("|⬡═══════════════════════════════════════════════════════════════| (c)Ѷ𝖑𝐤𝐲𝖗𝖊🕊️ʙʏ🕊️ᴋʀᴀᴋɪɴᴢʟᴀʙ™ |═══════════════════════════════════════════════════════════════⬡|");
# // ╔⧉༻ [ Ѷ𝖑𝐤𝐲𝖗𝖊🕊️𝐌𝐮𝐥𝐭𝐢𝐃𝐞𝐯𝐢𝐜𝐞 𝐀𝐏𝐈 ] 𝐢𝐬 𝐚 𝐖𝐡𝐚𝐭𝐬𝐚𝐩𝐩 𝐌𝐮𝐥𝐭𝐢𝐏𝐮𝐫𝐩𝐨𝐬𝐞-𝐔𝐬𝐞𝐫𝐛𝐨𝐭 𝐰𝐢𝐭𝐡 𝐌𝐨𝐝𝐞𝐫𝐚𝐭𝐢𝐨𝐧,𝐀𝐮𝐭𝐨𝐦𝐚𝐭𝐢𝐨𝐧 𝐚𝐧𝐝 𝟏𝟎𝟎+ 𝐦𝐨𝐫𝐞 𝐜𝐨𝐦𝐦𝐚𝐧𝐝𝐬!
# // ║ 🐞𝐃𝐞𝐯𝐞𝐥𝐨𝐩𝐞𝐫𝐬 +918436686758,917430922909
# // ║
# // ║ We won't be responsible for any kind of ban due to this bot.
# // ║ Vlkyre was made for fun purpose and to make group management easier.
# // ║ It's your concern if you spam and gets your account banned.
# // ║ Also, Forks won't be entertained.
# // ║ If you fork this repo and edit plugins, it's your concern for further updates.
# // ║ Forking Repo is fine. But if you edit something we will not provide any help.
# // ║ In short, Fork At Your Own Risk.
# // ╚════════════╝
# ("|⬡═══════════════════════════════════════════════════════════════| (c)Ѷ𝖑𝐤𝐲𝖗𝖊🕊️ʙʏ🕊️ᴋʀᴀᴋɪɴᴢʟᴀʙ™ |═══════════════════════════════════════════════════════════════⬡|");
FROM python:latest
ENV ᴋʀᴀᴋɪɴᴢ⌬ʟᴀʙ "/venv"
RUN python -m venv $ᴋʀᴀᴋɪɴᴢ⌬ʟᴀʙ
ENV PATH "$ᴋʀᴀᴋɪɴᴢ⌬ʟᴀʙ/bin:$PATH"
RUN apt update && apt install --no-install-recommends aptitude -y && rm -rf /var/lib/apt/lists/*;
RUN apt upgrade -y

RUN aptitude install jq -y
RUN aptitude install git -y
RUN aptitude install curl -y
RUN aptitude install wget -y
RUN aptitude install ffmpeg -y
RUN aptitude install nodejs -y
RUN aptitude install npm -y
RUN aptitude install bpm-tools -y
RUN aptitude install opus-tools -y
RUN aptitude install python3-pip -y
RUN aptitude install python-is-python3 -y
RUN curl -f -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl && chmod a+rx /usr/local/bin/youtube-dl
RUN curl -f https://cli-assets.heroku.com/install.sh | sh && heroku plugins:install heroku-builds
RUN git clone https://github.com/KryKnz/Vlkyre.git
RUN cd Vlkyre
WORKDIR /Vlkyre
RUN pip install --no-cache-dir -r Valkyrie🕊️Adapt/⭕𝖈𝖆𝖗𝖆.txt
RUN curl -f https://bun.sh/install | bash -E
RUN BUN_INSTALL="/root/.bun" && PATH="$BUN_INSTALL/bin:$PATH"
RUN npm install -g n yarn && npm cache clean --force;
RUN n install 16.15.1
RUN yarn global add --ignore-engine spotify-dl spdl-core typescript forever && yarn cache clean;
RUN yarn config set ignore-engines true && yarn cache clean;
RUN yarn install --ignore-engines && yarn cache clean;
RUN git config --global user.name "KryKnz"
RUN git config --global user.email "KrakinzKon@gmail.com"
RUN git config pull.rebase false
RUN git init --initial-branch=🐍Ş𝖎𝖕𝖍𝖔𝖓®
RUN git fetch origin 🐍Ş𝖎𝖕𝖍𝖔𝖓®
RUN git reset --hard origin/🐍Ş𝖎𝖕𝖍𝖔𝖓®
CMD python3 🌱𝖆𝖕𝖗𝖎𝖑𝖑𝖆.py
# ("|⬡═══════════════════════════════════════════════════════════════| (c)Ѷ𝖑𝐤𝐲𝖗𝖊🕊️ʙʏ🕊️ᴋʀᴀᴋɪɴᴢʟᴀʙ™ |═══════════════════════════════════════════════════════════════⬡|");
# // ╔⧉༻ [ Ѷ𝖑𝐤𝐲𝖗𝖊🕊️𝐌𝐮𝐥𝐭𝐢𝐃𝐞𝐯𝐢𝐜𝐞 𝐀𝐏𝐈 ] 𝐢𝐬 𝐚 𝐖𝐡𝐚𝐭𝐬𝐚𝐩𝐩 𝐌𝐮𝐥𝐭𝐢𝐏𝐮𝐫𝐩𝐨𝐬𝐞-𝐔𝐬𝐞𝐫𝐛𝐨𝐭 𝐰𝐢𝐭𝐡 𝐌𝐨𝐝𝐞𝐫𝐚𝐭𝐢𝐨𝐧,𝐀𝐮𝐭𝐨𝐦𝐚𝐭𝐢𝐨𝐧 𝐚𝐧𝐝 𝟏𝟎𝟎+ 𝐦𝐨𝐫𝐞 𝐜𝐨𝐦𝐦𝐚𝐧𝐝𝐬!
# // ║ 🐞𝐃𝐞𝐯𝐞𝐥𝐨𝐩𝐞𝐫𝐬 +918436686758,917430922909
# // ║
# // ║ We won't be responsible for any kind of ban due to this bot.
# // ║ Vlkyre was made for fun purpose and to make group management easier.
# // ║ It's your concern if you spam and gets your account banned.
# // ║ Also, Forks won't be entertained.
# // ║ If you fork this repo and edit plugins, it's your concern for further updates.
# // ║ Forking Repo is fine. But if you edit something we will not provide any help.
# // ║ In short, Fork At Your Own Risk.
# // ╚════════════╝
# ("|⬡═══════════════════════════════════════════════════════════════| (c)Ѷ𝖑𝐤𝐲𝖗𝖊🕊️ʙʏ🕊️ᴋʀᴀᴋɪɴᴢʟᴀʙ™ |═══════════════════════════════════════════════════════════════⬡|");