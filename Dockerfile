FROM wilkesystems/steamcmd:xenial

# silence misc warnings
ENV DEBIAN_FRONTEND noninteractive

# install dependencies
RUN dpkg --add-architecture i386
RUN apt-get update
RUN apt-get install -y lib32gcc1
RUN apt-get install -y lib32stdc++6
RUN apt-get install -y libcurl4-gnutls-dev:i386

# install DST
ENV ROOT /root/DST
ENV INSTALL_DIR $ROOT/install_dir
RUN steamcmd \
  +login anonymous \
  +force_install_dir $INSTALL_DIR \
  +app_update 343050 \
  +quit

# define folder structure
ENV KLEI $ROOT/.klei
ENV DNST $KLEI/DoNotStarveTogether
ENV CLUSTER_NAME Cluster
ENV CLUSTER $DNST/$CLUSTER_NAME

# add config files
ADD cluster/cluster_token.txt $CLUSTER/cluster_token.txt
ADD cluster/cluster.ini $CLUSTER/cluster.ini
ADD mods/dedicated_server_mods_setup.lua $INSTALL_DIR/mods/dedicated_server_mods_setup.lua
ADD mods/modsettings.lua $INSTALL_DIR/mods/modsettings.lua

# Steam / DST ports
EXPOSE 8768 8769 10889 11000 11001 27018 27019

# Override the default command
CMD \
  echo "ROOT = $ROOT" && \
  echo "INSTALL_DIR = $INSTALL_DIR" && \
  echo "KLEI = $KLEI" && \
  echo "DNST = $DNST" && \
  echo "CLUSTER_NAME = $CLUSTER_NAME" && \
  echo "CLUSTER = $CLUSTER"
