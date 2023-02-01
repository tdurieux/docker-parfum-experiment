FROM python:3.10-slim-bullseye

# Add testing to get newer SQLite (ugh)
RUN echo 'deb http://http.us.debian.org/debian/ testing non-free contrib main' >> /etc/apt/sources.list

# Install base apt dependencies
RUN apt-get update && apt-get install --no-install-recommends -y git sqlite3 && rm -rf /var/lib/apt/lists/*;

# Install auxiliary dependencies (for GL, Tex, etc.)
RUN apt-get install --no-install-recommends -y \
  libgl1-mesa-glx \
  texlive-latex-extra \
  texlive-fonts-extra \
  texlive-lang-greek \
  dvipng \
  ffmpeg \
  gcc && rm -rf /var/lib/apt/lists/*;

# Configure Git settings for update command
RUN git config --global user.name "Martlet"
RUN git config --global user.email "idoneam.collective@gmail.com"

# Install requirements with pip to use Docker cache independent of project metadata
COPY requirements.txt /mnt/
RUN pip install --no-cache-dir -r /mnt/requirements.txt

WORKDIR /mnt/canary
CMD ["python3.10", "Main.py"]
