# Docker-SOS
Docker **S**ync **O**n **S**ave 


# IDEA
Running Web Applications on Docker volume mounts is really slow especially for web developers. Most Apple and Windows users are aware about this problem. Vagrant partially solves this problem but puts another layer of complexity to your stack. 
Docker-SOS provides an easy workaround to solve this problem natively. 

# PERSPECTIVE
We've been playing with [eZ Systems](https://ez.no/de) and realized, that loading the example demo page takes **14 seconds** on 2017's MacBook Pro (same on Dell Laptop, Intel i5, SSD, Windows 10). Docker-SOS put it down to under **1 second**! 


# HOW IT WORKS
Docker-SOS listens on a mounted folder on your laptop. As soon theres a change on the source folder, the change will by synced to the target volume. Noting fancy here. Just an inotify listener on /source/ that triggers rsync to mirror the changes to /target. 

---
**NOTE**

This is a one way sync from source to target. The idea behind that is to to use a docker volume for your data (instead o a mounted volume). The volume is used to bypass the docker overlay bottleneck.

---

# QUICKSTART
```
docker build -t docker-sos:latest --force-rm -f Dockerfile . 
docker run --rm --name docker-sos -v ~/myLocalSyncFolder/:/source/ -d docker-sos:latest
docker exec -it sos-sync /bin/sh
```


# Build Image manually
```
docker build -t docker-sos:latest --force-rm -f Dockerfile . 
```

# Use Image
```
PROJECT="myProjectName"
docker run --rm --name docker-sos-$PROJECT -v ~/myLocalSyncFolder/:/source/ -d docker-sos:latest
docker exec -it sos-sync /bin/sh
```

# Advanced usage (clanup/debugging)
```
docker run --rm --name docker-sos-myproject -v ~/myLocalSyncFolder/:/source/ -d docker-sos:latest
docker exec -it sos-sync /bin/sh
```
# Project integration with docker-compose 


Start your example project
```
docker-compose up -d --build --force-recreate --remove-orphans
```

Exaple docker-compose.yml:
```
version: '3'
services:
  web:
    image: httpd
    ports:
      - "8080:80"
    volumes:
       - ~/myLocalSyncFolder/:/source/
       - target:/usr/local/apache2/htdocs/ 
  sos-sync:
    image: sebastianzoll/docker-sos
    volumes:
       - ~/myLocalSyncFolder/:/source/
       - target:/usr/local/apache2/htdocs/
volumes:
  target:
```


