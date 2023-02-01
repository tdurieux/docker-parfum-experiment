FROM stimela/base:1.7.1
RUN pip install --no-cache-dir astropy \
        numpy \
        scipy \
        futures \
        scikit-image

#RUN pip install git+https://github.com/SpheMakh/cleanmask
