FROM quay.io/stimela/astropy:1.7.1
RUN docker-apt-install montage vim
RUN pip install --no-cache-dir --upgrade pip setuptools
RUN pip install --no-cache-dir -U montage-wrapper >=0.9.9 astroquery >=0.3.8 git+https://github.com/ratt-ru/scabha.git@positional

