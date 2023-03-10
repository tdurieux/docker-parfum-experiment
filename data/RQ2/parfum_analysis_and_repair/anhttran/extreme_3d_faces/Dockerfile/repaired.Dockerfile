FROM mxnet/python:1.1.0_nccl

RUN apt-get update && apt-get install --no-install-recommends -y libhdf5-serial-dev libboost-all-dev nano cmake libosmesa6-dev freeglut3-dev && rm -rf /var/lib/apt/lists/*;
#RUN apt install zip
RUN wget https://dlib.net/files/dlib-19.6.tar.bz2; \
	tar xvf dlib-19.6.tar.bz2; rm dlib-19.6.tar.bz2 \
	cd dlib-19.6/; \
	mkdir build; \
	cd build; \
	cmake ..; \
	cmake --build . --config Release; \
	make install; \
	cd ..; \
	python setup.py install --yes USE_AVX_INSTRUCTIONS --yes DLIB_USE_CUDA

RUN pip install --no-cache-dir http://download.pytorch.org/whl/cu90/torch-0.3.1-cp27-cp27mu-linux_x86_64.whl
RUN pip install --no-cache-dir opencv-python torchvision==0.2.1 scikit-image cvbase pandas mmdnn

WORKDIR /app
ADD . /app

RUN mkdir build; \
	cd build; \
	cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=../demoCode ..; \
	make; \
	make install; \
	cd ..

WORKDIR /app/demoCode
EXPOSE 80

ENV NAME World

CMD ["python", "testBatchModel.py"]
