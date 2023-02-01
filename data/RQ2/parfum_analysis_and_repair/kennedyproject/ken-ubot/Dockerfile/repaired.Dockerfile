# Using Python Slim-Buster
FROM vckyouuu/geezprojects:buster
# Halo kak yahaha
# KEN-UBOT
#
RUN git clone -b KEN-UBOT https://github.com/KennedyProject/KEN-UBOT /root/userbot
RUN mkdir /root/userbot/.bin
RUN pip install --no-cache-dir --upgrade pip setuptools
WORKDIR /root/userbot

#Install python requirements
RUN pip3 install --no-cache-dir -r https://raw.githubusercontent.com/KennedyProject/KEN-UBOT/KEN-UBOT/requirements.txt

EXPOSE 80 443

# Finalization
CMD ["python3","-m","userbot"]
