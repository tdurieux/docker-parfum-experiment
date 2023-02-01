FROM hellozcb/face_recognition

RUN pip install --no-cache-dir --upgrade pip && \
  pip install --no-cache-dir imutils && \
  pip install --no-cache-dir opencv-python && \
  pip install --no-cache-dir --upgrade ptvsd && \
  pip install --no-cache-dir sklearn && \
  pip install --no-cache-dir Flask && \
  pip install --no-cache-dir isodate && \
  pip3 install --no-cache-dir tensorflow==1.15 && \
  pip3 install --no-cache-dir python-graphql-client && \
  pip3 install --no-cache-dir pillow && \
  pip3 install --no-cache-dir matplotlib && \
  pip3 install --no-cache-dir h5py && \
  pip3 install --no-cache-dir keras==2.2.4

RUN rm -f /app/models/shape_predictor_5_face_landmarks.dat.bz && \
  rm -f /app/models/shape_predictor_68_face_landmarks.dat.bz2

ADD https://github.com/davisking/dlib-models/raw/master/shape_predictor_5_face_landmarks.dat.bz2 /app/models/
ADD https://github.com/davisking/dlib-models/raw/master/shape_predictor_68_face_landmarks.dat.bz2 /app/models/

RUN bzip2 -d /app/models/shape_predictor_5_face_landmarks.dat.bz2 && \
  bzip2 -d /app/models/shape_predictor_68_face_landmarks.dat.bz2
