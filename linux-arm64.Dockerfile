FROM hotio/base@sha256:c46f6849510a863ff36db9c1804cf2a06a55419cff3b71f8f4a49ec3d9ba362c
ENV TAUTULLI_DOCKER="True"
EXPOSE 8181

RUN apk add --no-cache python3 py3-lxml py3-openssl py3-setuptools && \
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
