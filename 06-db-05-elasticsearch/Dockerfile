FROM centos:7


WORKDIR /opt/elasticsearch/
RUN yum -y install wget \
    && yum -y install perl-Digest-SHA \
    && wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.15.0-linux-x86_64.tar.gz \
    && wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.15.0-linux-x86_64.tar.gz.sha512 \
    && shasum -a 512 -c elasticsearch-7.15.0-linux-x86_64.tar.gz.sha512 \
    && tar -xzf elasticsearch-7.15.0-linux-x86_64.tar.gz \
    && rm -rf elasticsearch-7.15.0-linux-x86_64.tar.gz \
    && rm -rf https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.15.0-linux-x86_64.tar.gz.sha512  \
    && mkdir elasticsearch-7.15.0/snapshots \
    && chmod -R 777 elasticsearch-7.15.0/ \
    && mkdir /var/lib/elasitcsearch \
    && chmod -R 777 /var/lib/elasitcsearch/ \
    && adduser els

COPY configs/elasticsearch.yml elasticsearch-7.15.0/config/elasticsearch.yml
COPY configs/jvm.options elasticsearch-7.15.0/config/jvm.options
COPY configs/log4j2.properties elasticsearch-7.15.0/config/log4j2.properties

USER els

EXPOSE 9200

CMD ["./elasticsearch-7.15.0/bin/elasticsearch"]
