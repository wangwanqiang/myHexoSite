---
title: docker安装Gitlab
id: 151
categories:
  - docker
date: 2016-03-03 10:27:03
tags:
---

这里用到了一个第三方的镜像：

Step 1\. Launch a postgresql container

    docker run --name gitlab-postgresql -d \
        --env 'DB_NAME=gitlabhq_production' \
        --env 'DB_USER=gitlab' --env 'DB_PASS=password' \
        --volume /srv/docker/gitlab/postgresql:/var/lib/postgresql \
        sameersbn/postgresql:9.4-13
    `</pre>

    Step 2\. Launch a redis container

    <pre>`docker run --name gitlab-redis -d \
        --volume /srv/docker/gitlab/redis:/var/lib/redis \
        sameersbn/redis:latest
    `</pre>

    Step 3\. Launch the gitlab container

    <pre>`docker run --name gitlab -d \
        --link gitlab-postgresql:postgresql --link gitlab-redis:redisio \
        --publish 10022:22 --publish 10080:80 \
        --env 'GITLAB_PORT=10080' --env 'GITLAB_SSH_PORT=10022' \
        --env 'GITLAB_SECRETS_DB_KEY_BASE=long-and-random-alpha-numeric-string' \
        --volume /srv/docker/gitlab/gitlab:/home/git/data \
        sameersbn/gitlab:8.5.1

Please refer to Available Configuration Parameters to understand GITLAB_PORT and other configuration options

NOTE: Please allow a couple of minutes for the GitLab application to start.

Point your browser to http://localhost:10080 and login using the default username and password:

> username: root
>   password: 5iveL!fe