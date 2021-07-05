FROM plugins/ecr:latest as drone-ecr

FROM thegeeklab/drone-docker-buildx:latest

LABEL org.opencontainers.image.source https://github.com/bitprocessor/drone-docker-buildx-ecr

COPY --from=drone-ecr /bin/drone-ecr /bin
RUN ln -s /bin/drone-docker-buildx /bin/drone-docker

ENTRYPOINT ["/usr/local/bin/dockerd-entrypoint.sh", "/bin/drone-ecr"]