# Using Python Slim-Buster
FROM kyyex/kyy-userbot:busterv2
#━━━━━ Userbot Telegram ━━━━━
#━━━━━ By Tonic-Userbot ━━━━━

RUN apt-get update && apt-get upgrade -y
RUN apt-get install --no-install-recommends ffmpeg -y && rm -rf /var/lib/apt/lists/*;
RUN git clone -b Tonic-Userbot https://github.com/Toni880/Tonic-Userbot /root/userbot
RUN mkdir /root/userbot/.bin
RUN pip install --no-cache-dir --upgrade pip setuptools
WORKDIR /root/userbot

#Install python requirements
RUN pip3 install --no-cache-dir -r https://raw.githubusercontent.com/Toni880/Tonic-Userbot/Tonic-Userbot/requirements.txt

EXPOSE 80 443

# Finalization
CMD ["python3", "-m", "userbot"]
