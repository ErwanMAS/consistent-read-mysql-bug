#!/bin/bash
#
SOME_OLD_MYSQL="mysql/mysql-server:5.5.62-1.1.10=mysql_5_5_62"
SOME_OLD_MARIA="mariadb:5.5.64=maria_5_5_64"
SOME_OLD_PERCO="percona:5.5.61=perco_5_5_61"
#
SOME_MYSQL="mysql/mysql-server:8.0.19-1.1.15=mysql_8_0_19  mysql/mysql-server:8.0.4-1.1.3=mysql_8_0_4 mysql/mysql-server:8.0.1-1.0.0=mysql_8_0_1 mysql/mysql-server:5.7.29-1.1.15=mysql_5_7_29 mysql/mysql-server:5.7.18=mysql_5_7_18 mysql/mysql-server:5.7.17=mysql_5_7_17
            mysql/mysql-server:5.6.47-1.1.15=mysql_5_6_47  mysql/mysql-server:5.6.46-1.1.13=mysql_5_6_46 mysql/mysql-server:5.6.45-1.1.12=mysql_5_6_45 mysql/mysql-server:5.6.44-1.1.11=mysql_5_6_44 mysql/mysql-server:5.6.43-1.1.10=mysql_5_6_43 mysql/mysql-server:5.6.42-1.1.8=mysql_5_6_42  mysql/mysql-server:5.6.41-1.1.7=mysql_5_6_41  mysql/mysql-server:5.6.40-1.1.5=mysql_5_6_40
	    mysql/mysql-server:5.6.39-1.1.3=mysql_5_6_39  mysql/mysql-server:5.6.38-1.1.2=mysql_5_6_38  mysql/mysql-server:5.6.37-1.1.1=mysql_5_6_37
            mysql/mysql-server:5.6.36=mysql_5_6_36  mysql/mysql-server:5.6.35=mysql_5_6_35 mysql/mysql-server:5.6.23=mysql_5_6_23"
SOME_MARIA="mariadb:10.4.12=maria_10_4_12 mariadb:10.3.22=maria_10_3_22 mariadb:10.2.31=maria_10_2_31 mariadb:10.1.44=maria_10_1_44 mariadb:10.1.22=maria_10_1_22 mariadb:10.1.11=maria_10_1_11"
SOME_PERCO="percona:ps-8.0.18-9=perco_8_0_18 percona/percona-server:8.0.13=perco_8_0_13 percona:ps-5.7.29=perco_5_7_29 percona:5.7.18=perco_5_7_18 percona:5.7.17=perco_5_7_17 percona:ps-5.6.47=perco_5_6_47 percona:5.6.36=perco_5_6_36 percona:5.6.35=perco_5_6_35"
#
BUG_KO="mysql/mysql-server:5.6.35=mysql_5_6_35 mysql/mysql-server:5.7.17=mysql_5_7_17 percona:5.6.35=perco_5_6_35 percona:5.7.17=perco_5_7_17"
BUG_OK="mysql/mysql-server:5.6.36=mysql_5_6_36 mysql/mysql-server:5.7.18=mysql_5_7_18 percona:5.6.36=perco_5_6_36 percona:5.7.18=perco_5_7_18 mysql/mysql-server:5.7.29-1.1.15=mysql_5_7_29 percona:ps-5.7.29=perco_5_7_29 mysql/mysql-server:5.6.47-1.1.15=mysql_5_6_47 percona:ps-5.6.47=perco_5_6_47"
#
VERSION="case1"
#
PARA_CNT=12
C=0
for V in $SOME_MYSQL $SOME_MARIA $SOME_PERCO
do
        C=$(( $C + 1 ))
	(
                IMG=$( echo "$V"| cut -d= -f1)
                NAM=$( echo "$V"| cut -d= -f2)
                echo $IMG
                echo $NAM

                docker run --name ${NAM} -e MYSQL_ROOT_PASSWORD=test1234 -d ${IMG} || exit 1
		T=30
                while [ $( docker exec -i $NAM  mysqladmin -h localhost -u root -ptest1234 ping 2>&1 | grep -c 'mysqld is alive' ) -eq 0 -a $T -gt 0 ]
                do
                    sleep 2
		    T=$(( $T - 1 ))
                done
                docker exec -i $NAM  sh -c '/usr/bin/mysql  -u root -ptest1234  -h localhost -e "create database test ; " '

                FILTERCMD="sed 's/timestamp(6) NULL DEFAULT NULL/timestamp NULL DEFAULT NULL/' "
		( bzcat mysqldump/dump_bug_consistent_read.bz2                    | eval ${FILTERCMD}     | docker exec -i $NAM  sh -c '/usr/bin/mysql  -u root -ptest1234  -h localhost test ' ) &
		( bzcat mysqldump/dump_bug_consistent_read_feed.bz2               | eval ${FILTERCMD}     | docker exec -i $NAM  sh -c '/usr/bin/mysql  -u root -ptest1234  -h localhost test ' ) &

                wait
		#
                for F in bug_create_buggy.sql bug_buggy_chunks.sql bug_session_${VERSION}_a.sql bug_session_${VERSION}_b.sql
                do
                  cat $F | docker exec -i ${NAM} sh -c "dd of=/tmp/$F"
                done
                docker exec -i $NAM  sh -c 'cd /tmp; /usr/bin/mysql  -u root -ptest1234  -h localhost test -e "source bug_session_'${VERSION}'_a.sql"' > /tmp/output_${NAM}_session_${VERSION}_a.log 2>&1 &
                docker exec -i $NAM  sh -c 'cd /tmp; /usr/bin/mysql  -u root -ptest1234  -h localhost test -e "source bug_session_'${VERSION}'_b.sql"' > /tmp/output_${NAM}_session_${VERSION}_b.log 2>&1 &
                wait
                docker stop ${NAM}
                docker rm --volumes ${NAM}
	) &
       if [ $(( $C  % $PARA_CNT )) = 0 ]
       then
           wait
       fi
done
wait
echo version that are buggy
grep -l -e '_20000_.*: [1]' -e '_10000_.*: [2-9]' -e '_15000_.*: 1[0-4]' -e '_5000_.*: [0-4]'  /tmp/output_*n_${VERSION}_[ab].log  | sort -t_ -k3,5



