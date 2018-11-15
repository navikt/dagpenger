FROM navikt/java:11
ARG APP_NAME
ARG DIST_TAR
ADD ${DIST_TAR}.tar /app
RUN mkdir /app/bin \
  && mv /app/${DIST_TAR}/bin/${APP_NAME} /app/bin/app \
  && mv /app/${DIST_TAR}/lib /app/lib \
  && rm -rf /app/${DIST_TAR}