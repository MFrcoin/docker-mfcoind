
FROM centos:7

ARG MFC_VERSION=0.8.1
ARG MFC_TAG=v.0.8.1.0

RUN adduser --system mfcoin

ENV MFC_DATA=/home/mfcoin/.MFC
ENV MFCOIN_PREFIX=/home/mfcoin
ENV PATH=${MFCOIN_PREFIX}:$PATH
ENV RPC_PASSWORD=mfcpass
ENV RPC_USER=mfcuser

RUN yum install -y --setopt=tsflags=nodocs wget unzip git

RUN mkdir ${MFCOIN_PREFIX} \
    && cd ${MFCOIN_PREFIX}/ \
    && wget https://github.com/MFrcoin/MFCoin/releases/download/${MFC_TAG}/mfcoin-${MFC_VERSION}-linux.zip \
    && unzip mfcoin-${MFC_VERSION}-linux.zip -d ${MFCOIN_PREFIX}/ \
    && rm -f mfcoin-${MFC_VERSION}-linux.zip

COPY --from=gosu/assets /opt/gosu /opt/gosu
RUN set -x \
    && /opt/gosu/gosu.install.sh \
    && rm -fr /opt/gosu

RUN yum remove -y wget unzip git \
    && yum clean all \
    && rm -rf /var/cache/yum

COPY docker-entrypoint.sh /entrypoint.sh

VOLUME [${MFC_DATA}]

EXPOSE 22824 22825

ENTRYPOINT ["/entrypoint.sh"]

CMD ["mfcoind"]
