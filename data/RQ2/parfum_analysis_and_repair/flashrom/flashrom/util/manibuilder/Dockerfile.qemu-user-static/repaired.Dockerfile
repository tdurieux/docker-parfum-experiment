FROM multiarch/qemu-user-static:register

RUN sed -i -e's/ mipsn32 mipsn32el / /' /qemu-binfmt-conf.sh