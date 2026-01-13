ARG UPSTREAM_IMAGE
ARG UPSTREAM_TAG_SHA

FROM ${UPSTREAM_IMAGE}:${UPSTREAM_TAG_SHA}
EXPOSE 8181
ARG IMAGE_STATS
ENV IMAGE_STATS=${IMAGE_STATS} TAUTULLI_DOCKER="True" WEBUI_PORTS="8181/tcp"

RUN apk add --no-cache python3 py3-lxml py3-openssl py3-setuptools && \
    apk add --no-cache --virtual=build-dependencies py3-pip make gcc g++ python3-dev && \
    pip3 install --break-system-packages --no-cache-dir --upgrade plexapi pycryptodomex && \
    apk del --purge build-dependencies

ARG VERSION
ARG VERSION_BRANCH
RUN curl -fsSL "https://github.com/Tautulli/Tautulli/archive/v${VERSION}.tar.gz" | tar xzf - -C "${APP_DIR}" --strip-components=1 && \
    chmod -R u=rwX,go=rX "${APP_DIR}" && \
    echo "v${VERSION}" > "${APP_DIR}/version.txt" && \
    echo "${VERSION_BRANCH}" > "${APP_DIR}/branch.txt"

COPY root/ /
RUN find /etc/s6-overlay/s6-rc.d -name "run*" -execdir chmod +x {} +
