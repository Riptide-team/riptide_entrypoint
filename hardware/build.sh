docker buildx create --use --platform=linux/arm64,linux/amd64 --name emulated-multiarch --driver docker-container
docker run --privileged multiarch/qemu-user-static:latest --reset -p yes
docker buildx build --output type=docker,dest=- --tag riptide_hardware:latest . --platform=linux/arm64 > image.tar