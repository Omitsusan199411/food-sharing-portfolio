FROM ruby:2.6.6
ENV LANG C.UTF-8
ENV ENTRYKIT_VERSION 0.4.0
ENV QMAKE=/usr/lib/qt5/bin/qmake
ENV APP_ROOT /var/www/app


RUN mkdir -p /root/tmp
RUN cp -p /etc/localtime /etc/localtime.UTC \
    && cp -p /usr/share/zoneinfo/Japan /etc/localtime
RUN curl https://deb.nodesource.com/setup_12.x | bash
RUN curl https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN touch /tmp/mysql.sock
RUN chmod 777 /tmp/mysql.sock
ADD ./docker/prd/mysql/mysql.cnf /etc/mysql/mysql.cnf


# Setup UTC+9
RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
    bash \
    build-essential \
    sudo \
    perl \
    curl \
    wget \
    git \
    libcurl4-openssl-dev \
    libghc-yaml-dev \
    libqt5webkit5-dev \
    libxml2-dev \
    libxslt-dev \
    libyaml-dev \
    linux-headers-amd64 \
    default-mysql-client \
    locales \
    ruby-dev \
    ruby-json \
    sudo \
    tzdata \
    libpq-dev \
    nodejs \
    vim \
    nginx \
    supervisor \
    nodejs \
    yarn \
    zlib1g-dev && \
    apt-get clean -y && \
    rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*


RUN wget https://github.com/progrium/entrykit/releases/download/v${ENTRYKIT_VERSION}/entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz \
  && tar -xvzf entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz \
  && rm entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz \
  && mv entrykit /bin/entrykit \
  && chmod +x /bin/entrykit \
  && entrykit --symlink

# copy app
RUN mkdir -p $APP_ROOT
WORKDIR $APP_ROOT
# docker buildコマンドを実行した時に滞在しているディレクトリが基準（ . ）となる。COPYは単純にローカルファイルやディレクトリをコピーするのみ
COPY . $APP_ROOT

# bundle install
RUN bundle install --path vendor/bundle
RUN bundle exec rails assets:precompile RAILS_ENV=prd

# yarn install Preparation
RUN npm install n -g
RUN n 12.18.4

# aws-cli install
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-2.0.30.zip" -o "awscliv2.zip"
RUN unzip -n awscliv2.zip && sudo ./aws/install
RUN rm awscliv2.zip

##nginx
RUN groupadd nginx
RUN useradd -g nginx nginx
# 圧縮ファイルを解凍してコピーしたい時はADDを使う
ADD ./docker/prd/app/nginx/nginx.conf /etc/nginx/nginx.conf
ADD ./docker/prd/app/nginx/dev.defalut.conf /etc/nginx/conf.d/dev.defalut.conf

# link logs
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log
RUN ln -sf /dev/stdout /var/www/app/log/delayed_job.log

##supervisor
RUN mkdir -p /var/log/supervisor
ADD ./docker/prd/app/supervisor/app.conf /etc/supervisor/conf.d/app.conf

EXPOSE 80
CMD ["/usr/bin/supervisord"]
