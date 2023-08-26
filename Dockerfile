FROM centos:8

WORKDIR /github/workspace

RUN curl https://centos.mirror.garr.it/centos/RPM-GPG-KEY-CentOS-Official \
    >/etc/pki/rpm-gpg/RPM-GPG-KEY-centosofficial

RUN rm -fr /var/cache/* && dnf update -y centos-gpg-keys centos-repos \
    centos-stream-repos centos-stream-release centos-stream-repos \
    ca-certificates || echo "WARNING: repos update failed, continuing."

RUN dnf update -y || echo "WARNING: packages update failed, continuing."

RUN dnf install -y rpmdevtools dnf-plugins-core spectool && \
    dnf clean all && rm -r -f /var/cache/*

CMD spectool --get-files --all rpm/*.spec && \
    dnf builddep --assumeyes rpm/*.spec && \
    rpmbuild \
        --define '_topdir /github/workspace' \
        --define "_version $VERSION" \
        --define "_release $RELEASE" \
        --define "_dist .el8" \
        -ba rpm/*.spec
