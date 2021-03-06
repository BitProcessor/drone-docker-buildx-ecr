## Docker Buildx :heart: AWS :heart: Drone CI/CD

### What is this ?

The dockerfile in this repository allows you to build an AWS ECR plugin based on Docker Buildx for Drone.

Instead of rebuilding everything, it uses 2 upstream images:
* [thegeeklab/drone-docker-buildx](https://github.com/thegeeklab/drone-docker-buildx): a fork of the regular Drone Docker plugin which uses Docker Buildx to build multi-arch containers
* [plugins/ecr](https://github.com/drone-plugins/drone-docker): the original AWS ECR plugin from the [Drone](https://github.com/drone/drone) authors


### Where to get the plugin ?

The docker image is available here:

`docker pull ghcr.io/bitprocessor/drone-docker-buildx-ecr:1.0.0`

Note that this initial version only contains the amd64 version. You can use it to perform multi-platform builds with buildx on Drone, using a docker-runner on amd64.

### How to use it?

```
kind: pipeline
type: docker
name: default

steps:
- name: docker  
  image: ghcr.io/bitprocessor/drone-docker-buildx-ecr:1.0.0
  privileged: true       <= Can be avoided, look into privileged drone plugins
  settings:
    platforms:
      - linux/arm64
      - linux/amd64
    access_key:
      from_secret: AWS_ACCESS_KEY_ID
    secret_key:
      from_secret: AWS_SECRET_ACCESS_KEY
    repo: my-repo
    registry: 000000000000.dkr.ecr.us-east-1.amazonaws.com
    region: us-east-1
```
Refer to the [regular Drone ECR](http://plugins.drone.io/drone-plugins/drone-ecr/) plugin documentation for more options

### What kind of policy do I need to make this work?

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "ecr:CompleteLayerUpload",
                "ecr:BatchGetImage",
                "ecr:UploadLayerPart",
                "ecr:InitiateLayerUpload",
                "ecr:BatchCheckLayerAvailability",
                "ecr:PutImage"
            ],
            "Resource": "arn:aws:ecr:us-east-1:000000000000:repository/my-repo"
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": "ecr:GetAuthorizationToken",
            "Resource": "*"
        }
    ]
}
```