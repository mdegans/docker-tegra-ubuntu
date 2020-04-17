# valid choices: t210, t186, t194

set -ex

docker build --build-arg SOC="t210" -f "tegra-ubuntu.Dockerfile" -t mdegans/l4t-base:t210 .
docker tag mdegans/l4t-base:t210 mdegans/l4t-base:latest
docker tag mdegans/l4t-base:t210 mdegans/l4t-base:tx1
docker tag mdegans/l4t-base:t210 mdegans/l4t-base:nano
docker build --build-arg SOC="t194" -f "tegra-ubuntu.Dockerfile" -t mdegans/l4t-base:t194 .
docker tag mdegans/l4t-base:t194 mdegans/l4t-base:xavier
docker build --build-arg SOC="t186" -f "tegra-ubuntu.Dockerfile" -t mdegans/l4t-base:t186 .
docker tag mdegans/l4t-base:t186 mdegans/l4t-base:tx2
