#clonning repo
from /LEGEND-LX/PYTHONUSERBOT.git /root/userbot
RUN git clone https://github.com/LEGEND-LX/PYTHONUSERBOT.git /root/userbot
#working directory
WORKDIR /root/userbot

# Install requirements
RUN pip3 install --no-cache-dir -U -r requirements.txt

ENV PATH="/home/userbot/bin:$PATH"

CMD ["python3","-m","userbot"]
