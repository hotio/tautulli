FROM hotio/base@sha256:5c748f472fd4dda9c2332dbce09046f9b419d6776083ec17df1d4d8370eb5a0b
ENV TAUTULLI_DOCKER="True"
EXPOSE 8181

RUN apk add --no-cache python3 py3-lxml py3-openssl && \
    apk add --no-cache --virtual=build-dependencies py3-pip make gcc g++ python3-dev && \
    pip3 install --no-cache-dir --upgrade plexapi pycryptodomex && \
    apk del --purge build-dependencies

ARG TAUTULLI_VERSION
ARG TAUTULLI_BRANCH
RUN curl -fsSL "https://github.com/Tautulli/Tautulli/archive/v${TAUTULLI_VERSION}.tar.gz" | tar xzf - -C "${APP_DIR}" --strip-components=1 && \
    chmod -R u=rwX,go=rX "${APP_DIR}" && \
    echo "v${TAUTULLI_VERSION}" > "${APP_DIR}/version.txt" && \
    echo "${TAUTULLI_BRANCH}" > "${APP_DIR}/branch.txt"

COPY root/ /
