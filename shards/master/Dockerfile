FROM dstbase

ENV SHARD_NAME Master
ADD server.ini $CLUSTER/$SHARD_NAME/server.ini
ADD modoverrides.lua $CLUSTER/$SHARD_NAME/modoverrides.lua
ADD worldgenoverride.lua $CLUSTER/$SHARD_NAME/worldgenoverride.lua

EXPOSE 8768 10889 11000 27018

CMD \
  cd $INSTALL_DIR/bin && \
  ./dontstarve_dedicated_server_nullrenderer \
    -persistent_storage_root $KLEI \
    -shard $SHARD_NAME \
    -cluster $CLUSTER_NAME
