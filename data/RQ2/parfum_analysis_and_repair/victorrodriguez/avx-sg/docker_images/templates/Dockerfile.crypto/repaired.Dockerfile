FROM centos:latest

COPY basic_gf2p8affine_epi64_epi8 .
COPY basic_gf2p8affineinv_epi64_epi8 .
COPY basic_gf2p8mul_epi8 .
COPY basic_mm256_aesdec_epi128 .
COPY basic_mm256_aesdeclast_epi128 .
COPY basic__mm256_aesenc_epi128 .
COPY basic_mm256_aesenclast_epi128 .
COPY basic_mm256_clmulepi64_epi128 .
COPY basic_mm_clmulepi64_si128 .
COPY basic_vpmadd52huq_i_avx512 .
COPY basic_vpmadd52luq_i_avx512 .

CMD ./basic_gf2p8affine_epi64_epi8 && \
	./basic_gf2p8affineinv_epi64_epi8 && \
	./basic_gf2p8mul_epi8 && \
	./basic_mm256_aesdec_epi128 && \
	./basic_mm256_aesdeclast_epi128 && \
	./basic__mm256_aesenc_epi128 && \
	./basic_mm256_aesenclast_epi128.c && \
	./basic_mm256_clmulepi64_epi128 && \
	./basic_mm_clmulepi64_si128 && \
	./basic_vpmadd52huq_i_avx512 && \
	./basic_vpmadd52luq_i_avx512