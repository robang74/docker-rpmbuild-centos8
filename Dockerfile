FROM centos:8

WORKDIR /github/workspace

RUN dnf update -y

RUN dnf install -y rpmdevtools dnf-plugins-core spectool && \
    dnf clean all && \
    rm -r -f /var/cache/*

CMD spectool --get-files --all SPECS/*.spec && \
    dnf builddep --assumeyes SPECS/*.spec && \
    rpmbuild \
        --define '_topdir /github/workspace' \
        --define "_version $VERSION" \
        --define "_release $RELEASE" \
        --define "_dist .el8" \
        -ba SPECS/*.spec
