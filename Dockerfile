FROM --platform=$TARGETPLATFORM debian:12.11

ARG JBR_MAJOR
ARG JBR_PATCH

RUN apt-get clean && apt-get update && apt-get install -y curl tar zip binutils fakeroot wget libfuse2 fuse libglib2.0-0 file ca-certificates libstdc++6

RUN ARCH=$(dpkg --print-architecture) && \
    if [ "$ARCH" = "amd64" ]; then \
        URL="https://cache-redirector.jetbrains.com/intellij-jbr/jbrsdk-${JBR_MAJOR}-linux-x64-${JBR_PATCH}.tar.gz"; \
    elif [ "$ARCH" = "arm64" ]; then \
        URL="https://cache-redirector.jetbrains.com/intellij-jbr/jbrsdk-${JBR_MAJOR}-linux-aarch64-${JBR_PATCH}.tar.gz"; \
    else \
        echo "Unsupported architecture: $ARCH" && exit 1; \
    fi && \
    curl -L "$URL" -o jbr.tar.gz && \
    mkdir -p /opt/jbr && \
    tar -xzf jbr.tar.gz -C /opt/jbr --strip-components=1 && \
    rm jbr.tar.gz

ENV JAVA_HOME=/opt/jbr
ENV PATH="${JAVA_HOME}/bin:${PATH}"

