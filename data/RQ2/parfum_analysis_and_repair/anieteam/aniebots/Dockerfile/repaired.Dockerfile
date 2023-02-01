#Repo Clonning ⚡♥️
RUN git clone https://github.com/shiwabot/Aniebot.git /root/userbot

#working directory
WORKDIR /root/userbot

# Install requirements
RUN pip3 install --no-cache-dir -U -r requirements.txt

ENV PATH="/home/userbot/bin:$PATH"

CMD ["python3","-m","userbot"]
