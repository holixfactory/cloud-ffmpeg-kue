FROM alpine:3.4

ENV FFMPEG_VERSION=3.3.3

WORKDIR /tmp/ffmpeg

RUN apk add --update --no-cache\
      build-base \
      yasm-dev \
      nasm \
      curl \
      tar \
      bzip2 \
      zlib-dev \
      openssl-dev \
      libass-dev \
      freetype-dev \
      lame-dev \
      libogg-dev \
      libtheora-dev \
      libvorbis-dev \
      libwebp-dev \
      x264-dev \
      x265-dev \
      libvpx-dev \
      rtmpdump-dev \
      opus-dev; \

    DIR=$(mktemp -d) && cd ${DIR}; \
    curl -s http://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.gz | tar zxvf - -C . ; \
    cd ffmpeg-${FFMPEG_VERSION}; \
      ./configure \
        --enable-gpl \
        --enable-version3 \
        --enable-nonfree \

        --enable-small \

        --enable-postproc \
        --enable-avresample \

        --enable-libass \
        --enable-libfreetype \
        --enable-libmp3lame \
        --enable-libopus \
        --enable-librtmp \
        --enable-libtheora \
        --enable-libvorbis \
        --enable-libwebp \
        --enable-libx264 \
        --enable-libx265 \
        --enable-libvpx \

        --enable-openssl \
        --disable-debug; \

    make && \
    make install && \
    make distclean; \

    rm -rf ${DIR};

WORKDIR /

ENV NPM_CONFIG_LOGLEVEL info
ENV NODE_VERSION 6.11.2

RUN addgroup -g 1000 node \
    && adduser -u 1000 -G node -s /bin/sh -D node \
    && apk add --no-cache --virtual .build-deps \
        binutils-gold \
        gnupg \
        xz \
        linux-headers \
        python \
  # gpg keys listed at https://github.com/nodejs/node#release-team
  && for key in \
    9554F04D7259F04124DE6B476D5A82AC7E37093B \
    94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
    FD3A5288F042B6850C66B31F09FE44734EB7990E \
    71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
    DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
    B9AE9905FFD7803F25714661B63B535A4C206CA9 \
    C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
    56730D5401028683275BD23C23EFEFE93C4CFFFE \
  ; do \
    gpg --keyserver pgp.mit.edu --recv-keys "$key" || \
    gpg --keyserver keyserver.pgp.com --recv-keys "$key" || \
    gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key" ; \
  done \
    && curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION.tar.xz" \
    && curl -SLO --compressed "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" \
    && gpg --batch --decrypt --output SHASUMS256.txt SHASUMS256.txt.asc \
    && grep " node-v$NODE_VERSION.tar.xz\$" SHASUMS256.txt | sha256sum -c - \
    && tar -xf "node-v$NODE_VERSION.tar.xz" \
    && cd "node-v$NODE_VERSION" \
    && ./configure \
    && make -j$(getconf _NPROCESSORS_ONLN) \
    && make install \
    && apk del .build-deps \
    && cd .. \
    && rm -Rf "node-v$NODE_VERSION" \
    && rm "node-v$NODE_VERSION.tar.xz" SHASUMS256.txt.asc SHASUMS256.txt

ENV YARN_VERSION 0.27.5

RUN apk add --no-cache --virtual .build-deps-yarn curl gnupg tar \
  && for key in \
    6A010C5166006599AA17F08146C2130DFD2497F5 \
  ; do \
    gpg --keyserver pgp.mit.edu --recv-keys "$key" || \
    gpg --keyserver keyserver.pgp.com --recv-keys "$key" || \
    gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key" ; \
  done \
  && curl -fSLO --compressed "https://yarnpkg.com/downloads/$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz" \
  && curl -fSLO --compressed "https://yarnpkg.com/downloads/$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz.asc" \
  && gpg --batch --verify yarn-v$YARN_VERSION.tar.gz.asc yarn-v$YARN_VERSION.tar.gz \
  && mkdir -p /opt/yarn \
  && tar -xzf yarn-v$YARN_VERSION.tar.gz -C /opt/yarn --strip-components=1 \
  && ln -s /opt/yarn/bin/yarn /usr/local/bin/yarn \
  && ln -s /opt/yarn/bin/yarn /usr/local/bin/yarnpkg \
  && rm yarn-v$YARN_VERSION.tar.gz.asc yarn-v$YARN_VERSION.tar.gz \
  && apk del .build-deps-yarn

RUN npm install --global cloud-ffmpeg-kue; \
  apk del \
    build-base \
    binutils-gold \
    yasm-dev \
    nasm \
    gnupg \
    xz \
    linux-headers \
    curl \
    tar \
    zlib-dev \
    bzip2 \
    x264 \
    openssl \
    python \
  && rm -rf /var/cache/apk/*; 

CMD ["cloud-ffmpeg-kue"]
