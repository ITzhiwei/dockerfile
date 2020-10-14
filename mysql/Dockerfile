FROM centos:7
ENV MYSQLTARNAME mysql-5.7.30-linux-glibc2.12-x86_64
#设置root初始密码
ENV MYSQLPASSWORD 123456
RUN groupadd -r mysql && useradd -r -g mysql mysql;\
    yum install gcc gcc-c++ autoconf automake make openssl openssl-devel libaio sshpass net-tools numactl.x86_64 -y

COPY ./* /
# 如果本地没有 ${MYSQLTARNAME}.tar.gz 则使用wget下载
#RUN wget https://cdn.mysql.com/archives/mysql-5.7/${MYSQLTARNAME}.tar.gz
#COPY /my.cnf /etc/my.cnf  + ${MYSQLTARNAME}.tar.gz + /mysqlInitialize.sh
RUN tar -zxvf /${MYSQLTARNAME}.tar.gz;\
    mv $MYSQLTARNAME mysql;\
    mv mysql /usr/local/;\
    mkdir /usr/local/mysql/data;\
    rm /${MYSQLTARNAME}.tar.gz -rf;\
    mv /my.cnf /etc/my.cnf;\
    chown mysql:mysql /usr/local/mysql -R;\
    chown mysql /usr/local/mysql -R;\
    chmod 755 /usr/local/mysql -R;\
    cp /usr/local/mysql/support-files/mysql.server /etc/init.d/mysqld;\
    chmod 755 /etc/init.d/mysqld;\
    chown mysql:mysql /etc/my.cnf -R;\
    chmod 644 /etc/my.cnf;\
    mkdir /etc/my.cnf.d;\
    chown mysql:mysql /etc/my.cnf.d -R;\
    chmod 644 /etc/my.cnf.d;\
    chmod +x /mysqlInitialize.sh;

VOLUME ["/usr/local/mysql/data", "/etc/my.cnf.d"]
EXPOSE 3306
CMD /mysqlInitialize.sh















