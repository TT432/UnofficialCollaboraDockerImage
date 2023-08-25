FROM ubuntu:mantic

LABEL maintainer="2437315224@qq.com"

# 安装依赖
RUN apt update && \
    apt install -y dialog libpoco-dev python3-polib libcap-dev npm sudo \
                   libpam-dev libzstd-dev wget git build-essential libtool \
                   libcap2-bin python3-lxml libpng-dev libcppunit-dev \
                   pkg-config fontconfig snapd chromium-browser && \
    rm -rf /var/lib/apt/lists/*  # 清理 APT 缓存

WORKDIR /collabora

# 下载并解压 tarball
RUN wget https://github.com/CollaboraOnline/online/releases/download/for-code-assets/core-co-23.05-assets.tar.gz && \
    tar xvf core-co-23.05-assets.tar.gz && \
    rm core-co-23.05-assets.tar.gz  # 删除 tarball 文件

# 设置环境变量
ENV LOCOREPATH /collabora

# 克隆仓库
RUN git clone https://github.com/TT432/online.git collabora-online

WORKDIR /collabora/collabora-online

# 构建过程
RUN ./autogen.sh && \
    ./configure --enable-silent-rules --with-lokit-path=${LOCOREPATH}/include \
                --with-lo-path=${LOCOREPATH}/instdir \
                --enable-debug --enable-cypress && \
    make -j $(nproc)

CMD ["make", "run"]