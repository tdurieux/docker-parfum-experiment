ARG METPLUS_ENV_TAG=gempak
ARG METPLUS_IMG_TAG=develop

FROM dtcenter/metplus-envs:${METPLUS_ENV_TAG} as env

ARG METPLUS_IMG_TAG=develop
FROM dtcenter/metplus-dev:${METPLUS_IMG_TAG}

COPY --from=env /usr/lib/jvm/jre /usr/lib/jvm/jre/
COPY --from=env /usr/share/javazi-1.8/tzdb.dat /usr/share/javazi-1.8/
COPY --from=env /data/input/GempakToCF.jar /data/input/GempakToCF.jar