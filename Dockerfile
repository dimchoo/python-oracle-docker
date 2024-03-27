FROM python:3.12.1

COPY . /usr/src/app/

RUN apt-get update && apt-get install -y wget unzip libaio1

# Oracle:
ARG ORACLE_HOME=/oracle
ARG ORACLE_CLIENT_HOME=${ORACLE_HOME}/instantclient

RUN mkdir /tmp/oracle && \
    if [ "`uname -m`" = "aarch64" ] || [ "`uname -m`" = "arm64" ]; \
      then echo "ARM64 architecture detected" && wget https://download.oracle.com/otn_software/linux/instantclient/1919000/instantclient-basic-linux.arm64-19.19.0.0.0dbru.zip -P /tmp/oracle; \
    elif [ "`uname -m`" = "amd64" ] || [ "`uname -m`" = "x86_64" ] ; \
      then echo "AMD64 architecture detected" && wget https://download.oracle.com/otn_software/linux/instantclient/1920000/instantclient-basic-linux.x64-19.20.0.0.0dbru.zip -P /tmp/oracle; \
    else  \
      echo "target platform was not recognized : `uname -a`" && exit 1; \
    fi; \
    unzip /tmp/oracle/instantclient-basic-* -d /tmp/oracle && \
    mkdir -p ${ORACLE_CLIENT_HOME} && \
    mv /tmp/oracle/instantclient_*/* ${ORACLE_CLIENT_HOME} \

ENV LD_LIBRARY_PATH="${ORACLE_CLIENT_HOME}"

WORKDIR /usr/src/app/

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN pip install --upgrade pip
RUN pip install -r requirements.txt

