FROM stimela/aimfast:1.0.2
MAINTAINER <sphemakh@gmial.com>
ADD src /scratch/code
ENV LOGFILE ${OUTPUT}/logfile.txt
CMD /scratch/code/run.sh
