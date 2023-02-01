# 
# Recipe to bootstrap HPC Container Maker (HPCCM) as a container
# 
# Docker:
# $ sudo docker build -t hpccm -f Dockerfile .
# $ sudo docker run --rm -v $(pwd):/recipes hpccm --recipe /recipes/...
# 
# Singularity:
# $ sudo singularity build hpccm.simg Singularity.def
# $ singularity exec hpccm.simg --recipe ...
# 