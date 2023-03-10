FROM alpine:3.4

RUN apk update \
	&& apk add --no-cache bash gcc g++ make cmake zip unzip python \

	&& cd tmp \
	&& wget https://releases.llvm.org/6.0.1/llvm-6.0.1.src.tar.xz \
	&& tar xf llvm-6.0.1.src.tar.xz \
	&& rm llvm-6.0.1.src.tar.xz \
	&& cd llvm-6.0.1.src/tools \
	&& wget https://releases.llvm.org/6.0.1/cfe-6.0.1.src.tar.xz \
	&& tar xf cfe-6.0.1.src.tar.xz \
	&& rm cfe-6.0.1.src.tar.xz \
	&& mv cfe-6.0.1.src clang \
	&& cd ../.. \
	&& mkdir build \
	&& cd build \
	&& cmake -DCMAKE_BUILD_TYPE=Release -DLLVM_TARGETS_TO_BUILD="X86" -DLLVM_ENABLE_RTTI=TRUE -DLLVM_ENABLE_EH=TRUE ../llvm-6.0.1.src \
	&& make -j5 \
	&& make install \
	&& cd .. \
	&& rm -r build llvm-6.0.1.src

RUN adduser -D dev
USER dev

ENTRYPOINT ["/bin/bash", "-c"]
CMD [""]
