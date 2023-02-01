# Using Python Slim-Buster
FROM kyyex/kyy-userbot:busterv2
#━━━━━ Userbot Telegram ━━━━
#━━━━━ By Kyy-Userbot ━━━━━
#━━━━━ By Kyuraa-Userbot ━━━━━

RUN apt-get update && apt-get upgrade -y
RUN apt-get install --no-install-recommends ffmpeg -y && rm -rf /var/lib/apt/lists/*;
RUN git clone -b Warpath-Userbot https://github.com/Kyuraxp/warpath-userbot /root/userbot
RUN mkdir /root/userbot/.bin
RUN pip install --no-cache-dir --upgrade pip setuptools
WORKDIR /root/userbot

#Install python requirements
RUN pip3 install --no-cache-dir -r https://raw.githubusercontent.com/Kyuraxp/warpath-userbot/Warpath-Userbot/requirements.txt

EXPOSE 80 443

# Finalization
CMD ["python3", "-m", "userbot"]
