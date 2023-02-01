FROM archlinux:latest

RUN pacman -Syyu --noconfirm
RUN pacman -S --noconfirm python-pip zstd p7zip gcc
RUN pip3 install --no-cache-dir -U pip
RUN mkdir /app/
WORKDIR /app/
COPY . /app/
RUN pip3 install --no-cache-dir -U setuptools
RUN pip3 install --no-cache-dir -U -r requirements.txt
CMD bash start.sh
