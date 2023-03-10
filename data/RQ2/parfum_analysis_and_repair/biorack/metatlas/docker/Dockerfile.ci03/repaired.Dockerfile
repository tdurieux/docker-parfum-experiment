FROM python:3.8-slim-bullseye

# https://portal.nersc.gov/cfs/m2650/metatlas/test_data
# serves from /global/cfs/cdirs/m2650/www/metatlas/test_data
ARG BASE_DATA_URL=https://portal.nersc.gov/cfs/m2650/metatlas/test_data/ci03
ARG REFS_DIR=/global/cfs/cdirs/metatlas/projects/spectral_libraries
ARG H5_DIR=/global/cfs/cdirs/metatlas/raw_data/akuftin/20210915_JGI-AK_MK_506588_SoilWaterRep_final_QE-HF_C18_USDAY63680
ARG NOTES_DIR=/global/cfs/cdirs/m2650/targeted_analysis/

ENV METATLAS_LOCAL=True

EXPOSE 8888

RUN apt-get update && apt-get install --no-install-recommends -y \
        libxrender1 \
	git \
    && rm -rf /var/lib/apt/lists/*

ADD https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 /usr/local/bin/jq
RUN chmod +x /usr/local/bin/jq

RUN mkdir -p /io /src /work $REFS_DIR $H5_DIR

ADD $BASE_DATA_URL/msms_refs_v3.tab $REFS_DIR/

ADD $BASE_DATA_URL/20210915_JGI-AK_MK_506588_SoilWaterRep_final_QE-HF_C18_USDAY63680_NEG_MSMS_0_QC_Post_Rg80to1200-CE102040--QC_Run241.h5 $H5_DIR/
ADD $BASE_DATA_URL/20210915_JGI-AK_MK_506588_SoilWaterRep_final_QE-HF_C18_USDAY63680_NEG_MSMS_12_S16-D45_C_Rg80to1200-CE102040-soil-S1_Run203.h5 $H5_DIR/
ADD $BASE_DATA_URL/20210915_JGI-AK_MK_506588_SoilWaterRep_final_QE-HF_C18_USDAY63680_NEG_MSMS_18_S32-D45_C_Rg80to1200-CE102040-soil-S1_Run236.h5 $H5_DIR/
ADD $BASE_DATA_URL/20210915_JGI-AK_MK_506588_SoilWaterRep_final_QE-HF_C18_USDAY63680_NEG_MSMS_21_S16-D89_C_Rg80to1200-CE102040-soil-S1_Run221.h5 $H5_DIR/
ADD $BASE_DATA_URL/20210915_JGI-AK_MK_506588_SoilWaterRep_final_QE-HF_C18_USDAY63680_NEG_MSMS_33_S40-D30_C_Rg80to1200-CE102040-soil-S1_Run233.h5 $H5_DIR/
ADD $BASE_DATA_URL/20210915_JGI-AK_MK_506588_SoilWaterRep_final_QE-HF_C18_USDAY63680_NEG_MSMS_36_S53-D30_C_Rg80to1200-CE102040-soil-S1_Run218.h5 $H5_DIR/
ADD $BASE_DATA_URL/20210915_JGI-AK_MK_506588_SoilWaterRep_final_QE-HF_C18_USDAY63680_NEG_MSMS_45_S53-D45_C_Rg80to1200-CE102040-soil-S1_Run212.h5 $H5_DIR/
ADD $BASE_DATA_URL/20210915_JGI-AK_MK_506588_SoilWaterRep_final_QE-HF_C18_USDAY63680_NEG_MSMS_51_S40-D89_C_Rg80to1200-CE102040-soil-S1_Run227.h5 $H5_DIR/
ADD $BASE_DATA_URL/20210915_JGI-AK_MK_506588_SoilWaterRep_final_QE-HF_C18_USDAY63680_NEG_MSMS_54_S53-D89_C_Rg80to1200-CE102040-soil-S1_Run206.h5 $H5_DIR/
ADD $BASE_DATA_URL/20210915_JGI-AK_MK_506588_SoilWaterRep_final_QE-HF_C18_USDAY63680_NEG_MSMS_57_Neg-D30_C_Rg80to1200-CE102040-soil-S1_Run224.h5 $H5_DIR/
ADD $BASE_DATA_URL/20210915_JGI-AK_MK_506588_SoilWaterRep_final_QE-HF_C18_USDAY63680_NEG_MSMS_60_Neg-D45_C_Rg80to1200-CE102040-soil-S1_Run230.h5 $H5_DIR/
ADD $BASE_DATA_URL/20210915_JGI-AK_MK_506588_SoilWaterRep_final_QE-HF_C18_USDAY63680_NEG_MSMS_63_Neg-D89_C_Rg80to1200-CE102040-soil-S1_Run215.h5 $H5_DIR/
ADD $BASE_DATA_URL/20210915_JGI-AK_MK_506588_SoilWaterRep_final_QE-HF_C18_USDAY63680_NEG_MSMS_75_ExCtrl_C_Rg80to1200-CE102040-soil-S1_Run209.h5 $H5_DIR/

ADD $BASE_DATA_URL/meta_atlas_c18.sqlite3 /work/root_workspace.db

COPY requirements.txt /requirements.txt
RUN pip install --no-cache-dir --quiet -r requirements.txt

ADD $BASE_DATA_URL/instructions_for_analysts.csv $NOTES_DIR/

RUN mkdir -p /root/.local/share/jupyter/kernels/papermill
COPY papermill.kernel.json /root/.local/share/jupyter/kernels/papermill/kernel.json

RUN echo "1" > /metatlas_image_version

WORKDIR /work

ENV METATLAS_TEST=True
ENV PYTHONPATH=/src

CMD ["/usr/local/bin/jupyter", "lab", "--ip=0.0.0.0", "--allow-root", "--ServerApp.token=''", "--ServerApp.root_dir=/"]
