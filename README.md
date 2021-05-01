# [ryukaian/namecheap-dns](https://github.com/RyuKaian/docker-namecheap-dns)

based on [linuxserver/duckdns](https://github.com/linuxserver/docker-duckdns/tree/c731e5e1d1f6d2a43a267cb3471ed7ae144c7992) and [namecheap](https://www.namecheap.com/support/knowledgebase/article.aspx/29/11/how-do-i-use-a-browser-to-dynamically-update-the-hosts-ip/)

## Usage

Here are some example snippets to help you get started creating a container.

### docker-compose ([recommended](https://docs.linuxserver.io/general/docker-compose))

Compatible with docker-compose v2 schemas.

```yaml
---
version: "2.1"
services:
  namecheap-dns:
    image: ghcr.io/ryukaian/namecheap-dns
    container_name: namecheap-dns
    environment:
      - PUID=1000 #optional
      - PGID=1000 #optional
      - TZ=Europe/London
      - DOMAIN=domain
      - HOSTS=host1,host2
      - TOKEN=token
      - LOG_FILE=false #optional
    volumes:
      - /path/to/appdata/config:/config #optional
    restart: unless-stopped
```

### docker cli

```bash
docker run -d \
  --name=namecheap-dns \
  -e PUID=1000 `#optional` \
  -e PGID=1000 `#optional` \
  -e TZ=Europe/London \
  -e DOMAIN=domain\
  -e HOSTS=host1,host2 \
  -e TOKEN=token \
  -e LOG_FILE=false `#optional` \
  -v /path/to/appdata/config:/config `#optional` \
  --restart unless-stopped \
  ghcr.io/ryukaian/namecheap-dns
```

## Parameters

Container images are configured using parameters passed at runtime (such as those above). These parameters are separated by a colon and indicate `<external>:<internal>` respectively. For example, `-p 8080:80` would expose port `80` from inside the container to be accessible from the host's IP on port `8080` outside the container.

| Parameter | Function |
| :----: | --- |
| `-e PUID=1000` | for UserID - see below for explanation |
| `-e PGID=1000` | for GroupID - see below for explanation |
| `-e TZ=Europe/London` | Specify a timezone to use EG Europe/London |
| `-e DOMAIN` | domain name to be updated |
| `-e HOSTS=host1,host2` | multiple subdomains allowed, comma separated, no spaces |
| `-e TOKEN=token` | namecheap dynamic dns token |
| `-e LOG_FILE=false` | Set to `true` to log to file (also need to map /config). |
| `-v /config` | Used in conjunction with logging to file. |

## Environment variables from files (Docker secrets)

You can set any environment variable from a file by using a special prepend `FILE__`.

As an example:

```bash
-e FILE__PASSWORD=/run/secrets/mysecretpassword
```

Will set the environment variable `PASSWORD` based on the contents of the `/run/secrets/mysecretpassword` file.

## User / Group Identifiers

When using volumes (`-v` flags) permissions issues can arise between the host OS and the container, we avoid this issue by allowing you to specify the user `PUID` and group `PGID`.

Ensure any volume directories on the host are owned by the same user you specify and any permissions issues will vanish like magic.

In this instance `PUID=1000` and `PGID=1000`, to find yours use `id user` as below:

```bash
  $ id username
    uid=1000(dockeruser) gid=1000(dockergroup) groups=1000(dockergroup)
```

You only need to set the PUID and PGID variables if you are mounting the /config folder

## Support Info

* Shell access whilst the container is running: `docker exec -it namecheap-dns /bin/bash`
* To monitor the logs of the container in realtime: `docker logs -f namecheap-dns`
* container version number
  * `docker inspect -f '{{ index .Config.Labels "build_version" }}' namecheap-dns`
* image version number
  * `docker inspect -f '{{ index .Config.Labels "build_version" }}' ghcr.io/ryukaian/namecheap-dns`

## Updating Info

Most of our images are static, versioned, and require an image update and container recreation to update the app inside. With some exceptions (ie. nextcloud, plex), we do not recommend or support updating apps inside the container. Please consult the [Application Setup](#application-setup) section above to see if it is recommended for the image.

Below are the instructions for updating containers:

### Via Docker Compose

* Update all images: `docker-compose pull`
  * or update a single image: `docker-compose pull namecheap-dns`
* Let compose update all containers as necessary: `docker-compose up -d`
  * or update a single container: `docker-compose up -d namecheap-dns`
* You can also remove the old dangling images: `docker image prune`

### Via Docker Run

* Update the image: `docker pull ghcr.io/ryukaian/namecheap-dns`
* Stop the running container: `docker stop namecheap-dns`
* Delete the container: `docker rm namecheap-dns`
* Recreate a new container with the same docker run parameters as instructed above (if mapped correctly to a host folder, your `/config` folder and settings will be preserved)
* You can also remove the old dangling images: `docker image prune`

### Via Watchtower auto-updater (only use if you don't remember the original parameters)

* Pull the latest image at its tag and replace it with the same env variables in one run:

  ```bash
  docker run --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  containrrr/watchtower \
  --run-once namecheap-dns
  ```

* You can also remove the old dangling images: `docker image prune`

**Note:** We do not endorse the use of Watchtower as a solution to automated updates of existing Docker containers. In fact we generally discourage automated updates. However, this is a useful tool for one-time manual updates of containers where you have forgotten the original parameters. In the long term, we highly recommend using [Docker Compose](https://docs.linuxserver.io/general/docker-compose).

## Building locally

If you want to make local modifications to these images for development purposes or just to customize the logic:

```bash
git clone https://github.com/RyuKaian/docker-namecheap-dns.git
cd docker-namecheap-dns
docker build \
  --no-cache \
  --pull \
  -t ghcr.io/ryukaian/namecheap-dns:latest .
```