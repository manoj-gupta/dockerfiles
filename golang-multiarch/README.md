# Creating multi-arch Docker images

To create our own multi-arch Docker images we will first need multi-arch base images. One place to consider is the Docker Official images. For example, the golang:alpine image.

## Minimum dockerfile to try out

```
FROM golang:alpine AS build
ARG TARGETPLATFORM
ARG BUILDPLATFORM
RUN echo "I was built on a platform running on $BUILDPLATFORM, building this image for $TARGETPLATFORM" > /log

FROM alpine
COPY --from=build /log /log
CMD [ "cat", "/log" ]
```

## Use `docker buildx` on Mac, you may still get an error:

```
$ docker buildx build --platform linux/amd64,linux/arm/v7 .
Multiple platforms feature is currently not supported for docker driver.
Please switch to a different driver (eg. "docker buildx create --use")
```

## Create an isolated Builder Instance that supported multiple platforms:

```
$ docker buildx create --use
inspiring_benz
$ docker buildx ls
NAME/NODE DRIVER/ENDPOINT STATUS  PLATFORMS
NAME/NODE         DRIVER/ENDPOINT             STATUS   PLATFORMS
inspiring_benz *  docker-container
  inspiring_benz0 unix:///var/run/docker.sock inactive
default           docker
  default         default                     running  linux/amd64, linux/arm64, linux/ppc64le, linux/s390x, linux/386, linux/arm/v7, linux/arm/v6
```

## Build this Dockerfile for multiple platform architectures

```
docker buildx build \
  --platform linux/amd64,linux/arm64,linux/arm/v7,linux/arm/v6 \
  --tag starkandwayne/hello-multiarch:cat-log \
  --push \
  .
```

## Confirm the published  image for multiple platform architectures

```
$ docker container run mplatform/mquery starkandwayne/hello-multiarch:cat-log
Image: starkandwayne/hello-multiarch
 * Manifest List: Yes
 * Supported platforms:
   - linux/amd64
   - linux/arm64
   - linux/arm/v7
   - linux/arm/v6
```

## Try out `linux/amd64` image locally

```
$ docker pull starkandwayne/hello-multiarch:cat-log
$ docker run -ti starkandwayne/hello-multiarch:cat-log
I was built on a platform running on linux/amd64, building this image for linux/amd64
```

## Try out `linux/arm/v7` image on pine64

```
pine@blossom:~$ docker run -it manojgupta/hello-multiarch:cat-log
I was built on a platform running on linux/amd64, building this image for linux/arm/v7
pine@blossom:~$ env | grep -i k3
pine@blossom:~$ 
```