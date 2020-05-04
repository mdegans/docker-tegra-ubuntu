# valid choices: t210, t186, t194

readonly JETPACK_VERSION=r32.4.2

set -ex

docker build \
    --build-arg SOC="t210" \
    --build-arg JETPACK_VERSION=$JETPACK_VERSION \
    -f "tegra-ubuntu.Dockerfile" -t mdegans/l4t-base:t210 .
docker tag mdegans/l4t-base:t210 mdegans/l4t-base:latest
docker tag mdegans/l4t-base:t210 mdegans/l4t-base:nano
docker tag mdegans/l4t-base:t210 mdegans/l4t-base:$JETPACK_VERSION
docker tag mdegans/l4t-base:t210 mdegans/l4t-base:$JETPACK_VERSION-tx1
docker tag mdegans/l4t-base:t210 mdegans/l4t-base:$JETPACK_VERSION-nano
docker build \
    --build-arg SOC="t194" \
    --build-arg JETPACK_VERSION=$JETPACK_VERSION \
    -f "tegra-ubuntu.Dockerfile" -t mdegans/l4t-base:t194 .
docker tag mdegans/l4t-base:t194 mdegans/l4t-base:xavier
docker tag mdegans/l4t-base:t194 mdegans/l4t-base:$JETPACK_VERSION-xavier
docker build \
    --build-arg SOC="t186" \
    --build-arg JETPACK_VERSION=$JETPACK_VERSION \
    -f "tegra-ubuntu.Dockerfile" -t mdegans/l4t-base:t186 .
docker tag mdegans/l4t-base:t186 mdegans/l4t-base:tx2
docker tag mdegans/l4t-base:t186 mdegans/l4t-base:$JETPACK_VERSION-tx2
