FROM centos:7

LABEL name="kube-diag" \
    vendor="CentOS" \
    os-version="7" \
    license="GPLv2" \
    build-date="20170717" \
    oc-client-version="v1.5.1-7b451fc-linux-64bit" \
    kubectl-version="1.7.0" \
    maintainer="sahinerokan@gmail.com" 

RUN yum-config-manager --add-repo https://openresty.org/package/centos/openresty.repo \
&& yum install -y \
wget \
nmap \
ping \
telnet \
curl \
openssl \
openresty \
&& yum clean all \
&& wget -q https://storage.googleapis.com/kubernetes-release/release/v1.7.0/bin/linux/amd64/kubectl -O /bin/kubectl \
&& chmod 755 /bin/kubectl \
&& mkdir /bin/oc_client \
&& wget -q https://github.com/openshift/origin/releases/download/v1.5.1/openshift-origin-client-tools-v1.5.1-7b451fc-linux-64bit.tar.gz -O /bin/oc_client/oc_client.tar.gz \
&& tar -zxvf /bin/oc_client/oc_client.tar.gz -C /bin/oc_client/ \
&& mv /bin/oc_client/openshift-origin-client-tools-v1.5.1-7b451fc-linux-64bit/oc /bin/ \
&& rm -rf /bin/oc_client \ 
&& wget -q https://raw.githubusercontent.com/bungle/lua-resty-template/master/lib/resty/template.lua -O /usr/local/openresty/site/lualib/template.lua \
&& ln -sf /dev/stdout /usr/local/openresty/nginx/logs/access.log \
&& ln -sf /dev/stderr /usr/local/openresty/nginx/logs/error.log 

RUN useradd -rm -d /home/milmar02 -s /bin/bash -g root -u 1000 milmar02
USER milmar02
WORKDIR /home/milmar02

ADD nginx.conf /usr/local/openresty/nginx/conf/nginx.conf
ADD entrypoint.sh /entrypoint.sh

RUN chmod -R g+w /usr/local/openresty \
&& chmod g+x /entrypoint.sh


EXPOSE 8080
ENTRYPOINT ["/entrypoint.sh"]

