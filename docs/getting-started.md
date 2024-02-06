# Getting Started

Run the following to download the latest container from Docker Hub:

```bash
docker pull harbor.sydeng.vmware.com/rcroft/mkdocs:latest
```

Run the following to download a specific version from Docker Hub:

```bash
docker pull harbor.sydeng.vmware.com/rcroft/mkdocs:x.y.z
docker pull harbor.sydeng.vmware.com/rcroft/mkdocs:dev
```

Open an interactive terminal:

```bash
docker run --rm -it harbor.sydeng.vmware.com/rcroft/mkdocs bash
```

Run a local plan:

```bash
cd /path/to/files
docker run --rm -it --name mkdocs -v $(pwd):/tmp -w /tmp harbor.sydeng.vmware.com/rcroft/mkdocs bash --version
docker run --rm -it --name mkdocs -v $(pwd):/tmp -w /tmp harbor.sydeng.vmware.com/rcroft/mkdocs mkdocs version
```

Where `/path/to/files` is the local path for your scripts.
