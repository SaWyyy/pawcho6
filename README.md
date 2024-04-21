# Lab6 - University report
This task is about cloning app files from previous repository instead of copying them from machne.

## Preparation
First of all you will need buildctl, if you don't have it, you can download it from https://github.com/moby/buildkit/releases/tag/v0.13.1. \
On linux based system after extracting tar.gz copy content of bin folder to your /bin/ path, example: \
If you're in bin folder:
```sh
cp ./* /bin/
```
Now check if installation is successful by typing in terminal:
```sh
buildctl
```

## Building process
Next step is to run buildkit in a container:
```sh
docker run -d --name buildkitd --privileged moby/buildkit:latest
```
After that you need to point out the default host to variable BUILDKIT_HOST:
```sh
export BUILD_HOST=docker-container://buildkitd
```
One before last step is build an image with buildctl:
```sh
buildctl build --frontend=dockerfile.v0 --ssh default=$SSH_AUTH_SOCK --local context=. --local dockerfile=. --opt build-arg:VERSION=1.0.0 --output type=image,name=ghcr.io/sawyyy/pawcho6:lab6,push=true
```
Last step - starting container:
```sh
docker run -d --rm -p 80:80 --name app ghcr.io/sawyyy/pawcho6:lab6
```
## Testing
After running containter you can test if it's working by typing in terminal (if you have curl installed):
```sh
curl http://localhost:80
```
Or just put:
```sh
http://localhost:80
```
In your web browser

## Disclaimer
If you encounter an error: \
\
error: listing workers for Build: failed to list workers: Unavailable: connection error: desc = "error reading server preface: command [docker exec -i buildkitd buildctl dial-stdio] has exited with exit status 1, please make sure the URL is valid, and Docker 18.09 or later is installed on the remote host: stderr=Error response from daemon: No such container: buildkitd\n"
\
\
Check if name of buildkit container is same as name at the end of export command
\
\
Also make sure if port 80 isn't already allocated, otherway you change it in docker run command



