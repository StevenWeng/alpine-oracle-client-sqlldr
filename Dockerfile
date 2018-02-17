FROM alpine:3.5

LABEL maintainer=wosteven@gamil.com

# glibc
ENV GLIBC_REPO=https://github.com/sgerrand/alpine-pkg-glibc \
    GLIBC_VERSION=2.26-r0 \
    LANG=C.UTF-8
RUN apk update && \
    apk add rpm libaio libstdc++ curl --update --no-cache && \
    for pkg in glibc-${GLIBC_VERSION} glibc-bin-${GLIBC_VERSION} glibc-i18n-${GLIBC_VERSION}; do curl -sSL ${GLIBC_REPO}/releases/download/${GLIBC_VERSION}/${pkg}.apk -o /tmp/${pkg}.apk; done && \
    apk add --allow-untrusted /tmp/*.apk && \
    rm -v /tmp/*.apk && \
    ( /usr/glibc-compat/bin/localedef --force --inputfile POSIX --charmap UTF-8 C.UTF-8 || true ) && \
    echo "export LANG=C.UTF-8" > /etc/profile.d/locale.sh && \
    /usr/glibc-compat/sbin/ldconfig /lib /usr/glibc-compat/lib

# sqlldr
ENV ORACLE_HOME=/usr/lib/oracle/11.2/client64
ENV PATH=$PATH:$ORACLE_HOME/bin \
    LD_LIBRARY_PATH=$ORACLE_HOME/lib \
    TNS_ADMIN=$ORACLE_HOME/network/admin 

COPY instantclient/11.2.0.4.0 /tmp/instantclient
RUN rpm -ihv /tmp/instantclient/oracle-instantclient11.2-* --nodeps && \
    mkdir -p $ORACLE_HOME/rdbms/mesg && \
    cp /tmp/instantclient/sqlldr $ORACLE_HOME/bin/ && \
    chmod 755 $ORACLE_HOME/bin/sqlldr && \
    cp /tmp/instantclient/ulus.msb $ORACLE_HOME/rdbms/mesg/




ENTRYPOINT [ "/bin/sh" ]