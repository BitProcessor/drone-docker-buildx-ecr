FROM plugins/ecr:latest as drone-ecr

FROM thegeeklab/drone-docker-buildx:latest

COPY --from=drone-ecr /bin/drone-ecr /bin
RUN ln -s /bin/drone-docker-buildx /bin/drone-docker

ENTRYPOINT ["/usr/local/bin/dockerd-entrypoint.sh", "/bin/drone-ecr"]