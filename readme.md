# DST Server Container

This project automates the setup of a DST server with the main
overworld, cave underworld, and mods. It should work on any platform
that supports Docker and Docker Compose (Windows / Mac / Linux).

For ease of use, all configuration files are checked-in to the repo
to serve as an example / bootstrap. You should just need to add the cluster
token and run the build command to get it running (detailed instructions below).

Some information here may become out of date. If something is not
working, check the Klei formums
[here](https://forums.kleientertainment.com/)
first, and report any problems as a git issue here.

# Setup

1. Install Docker (`17.06.0+` or newer) and Docker Compose on your system.
    Official instructions for docker
    [here](https://docs.docker.com/engine/installation/), and compose
    [here](https://docs.docker.com/compose/install/).

    Eg, quickstart for Ubuntu:

    ```bash
    sudo apt-get update
    # install docker
    sudo apt-get install \
      apt-transport-https \
      ca-certificates \
      curl \
      software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository \
      "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) \
      stable"
    sudo apt-get update
    sudo apt-get install docker-ce
    # install docker-compose (NOTE: hardcoded version here, you should get the latest)
    sudo curl -L https://github.com/docker/compose/releases/download/1.18.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    ```

1. Clone / download this repository

1. Create the `cluster/cluster_token.txt` file.

    The contents of this file should be obtained as follows:

    * Start Don't Starve Together from Steam and click on the "Play!" button.
    * Click on the "Acct Info" button.
    * Click on the "Generate Server Token" button
    * Copy the token into the `cluster_token.txt` file

1. Modify the following files to your liking:

    * `cluster/cluster.ini` -- contains general settings for the server like
      it's name, the maximum number of players allowed, etc.
      See the `readme.cluster.md` file for a description of
      the options.
    * `mods/dedicated_server_mods_setup.lua` -- define the mods you wish to use.
    * `mods/modsettings.lua` -- extra settings for mods.
    * `shards/master/server.ini` and `shards/caves/server.ini` -- define server settings. See the `readme.server.md` file
      for a description of the options.
    * `shards/master/modoverrides.lua` and `shards/caves/modoverrides.lua` -- enable and configure mods.
    * `shards/master/worldgenoverride.lua` and `shards/caves/worldgenoverride.lua` -- world generation settings.

# Usage

**Run**

```
docker-compose build
docker-compose up
```

NOTE: This uses the "volumes" feature of docker to persist world
data across reboots. If you need to modify settings after running
the `build` command, you can find the files used by the container
in the `/var/lib/docker/volumes/` directory on the host computer.
You can see all volumes that docker is using with the
`docker volume ls` command. The name of the volume that docker
will assign to this volume will be of the form
`<folder of docker project>_dst`.
If you do not need to retain your world data and you just want to
start fresh, try this:

``` bash
docker-compose down
docker-compose rm -f

# find all dst images using:
docker images
# remove them with:
#   docker rmi -f [<image ID>]
# eg:
docker rmi -f a6sj6v69 sf8sdf7s9 sd87dfg5d

# WARNING: NEXT LINE DELETES ALL DATA
docker volume rm -f thisFolderName_dst

docker-compose build
docker-compose up
```

**Update**

The world data is saved in a volume outside of the
docker containers, so you can update steamcmd, dst,
and mods by rebuilding the images:

```bash
docker-compose down
docker-compose rm -f

# find all dst images using:
docker images
# remove them with:
#   docker rmi -f [<image ID>]
# eg:
docker rmi -f a6s6v69 sf8sdf7s9 sd87dfg5d

# rebuild
docker-compose build
docker-compose up
```

If you want to be more selective about what you update, you
can ssh into the running containers like this:

```bash
# container needs to be running before we can shell into it
docker-compose up
# this will list all running containers
docker ps
# find the id of the "master" or "caves" container, for example "797eebb72d77"
docker exec -it 797eebb72d77 /bin/bash
# now you have a bash terminal inside the container, and you
# can run whatever commands you want, like `steamcmd`.
```
