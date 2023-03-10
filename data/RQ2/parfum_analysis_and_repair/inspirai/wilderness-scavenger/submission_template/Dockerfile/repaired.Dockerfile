FROM python:latest

WORKDIR /tmp/install
RUN pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
RUN pip install --no-cache-dir -U pip && pip install --no-cache-dir https://codeload.github.com/inspirai/wilderness-scavenger/zip/refs/heads/master

# add your additional python denpendencies in the requirements.txt file
COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# ========================================================
# Install other non-python dependencies here (if any)
# ========================================================

# DO NOT MODIFY BELOW THIS LINE
WORKDIR /home/inspirai
COPY submission submission
COPY run.sh run.sh
