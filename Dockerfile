FROM alpine:3.5

LABEL maintainer=wosteven@gamil.com

RUN apk update && \
    apk add rpm libaio --update --no-cache

ENV ORACLE_HOME=/usr/lib/oracle/11.2/client64
ENV PATH=$PATH:$ORACLE_HOME/bin 
ENV LD_LIBRARY_PATH=$ORACLE_HOME/lib 
ENV TNS_ADMIN=$ORACLE_HOME/network/admin

COPY instantclient/11.2.0.4.0 /tmp/instantclient
RUN rpm -ihv /tmp/instantclient/oracle-instantclient11.2-* --nodeps && \
    mkdir -p $ORACLE_HOME/rdbms/mesg && \
    cp /tmp/instantclient/sqlldr $ORACLE_HOME/bin/ && \
    cp /tmp/instantclient/ulus.msb $ORACLE_HOME/rdbms/mesg/




ENTRYPOINT [ "/bin/sh" ]