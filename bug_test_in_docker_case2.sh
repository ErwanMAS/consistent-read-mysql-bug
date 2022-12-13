#!/bin/bash
#
SOME_OLD_MYSQL="mysql/mysql-server:5.5.62-1.1.10=mysql_5_5_62"
SOME_OLD_MARIA="mariadb:5.5.64=maria_5_5_64"
SOME_OLD_PERCO="percona:5.5.61=perco_5_5_61"
#
SOME_MYSQL="mysql/mysql-server:8.0.31=mysql_8_0_31 mysql/mysql-server:8.0.30=mysql_8_0_30
	    mysql/mysql-server:8.0.28=mysql_8_0_28 mysql/mysql-server:8.0.27=mysql_8_0_27 mysql/mysql-server:8.0.26=mysql_8_0_26
	    mysql/mysql-server:8.0.25=mysql_8_0_25 mysql/mysql-server:8.0.24=mysql_8_0_24 mysql/mysql-server:8.0.23=mysql_8_0_23
	    mysql/mysql-server:8.0.22=mysql_8_0_22 mysql/mysql-server:8.0.21=mysql_8_0_21 mysql/mysql-server:8.0.20=mysql_8_0_20
            mysql/mysql-server:8.0.19-1.1.15=mysql_8_0_19  mysql/mysql-server:8.0.4-1.1.3=mysql_8_0_4 mysql/mysql-server:8.0.1-1.0.0=mysql_8_0_1
            mysql/mysql-server:5.7.40=mysql_5_7_40 mysql/mysql-server:5.7.39=mysql_5_7_39
            mysql/mysql-server:5.7.38=mysql_5_7_38 mysql/mysql-server:5.7.37=mysql_5_7_37 mysql/mysql-server:5.7.36=mysql_5_7_36
            mysql/mysql-server:5.7.35=mysql_5_7_35 mysql/mysql-server:5.7.34=mysql_5_7_34 mysql/mysql-server:5.7.33=mysql_5_7_33
            mysql/mysql-server:5.7.32=mysql_5_7_32 mysql/mysql-server:5.7.31=mysql_5_7_31 mysql/mysql-server:5.7.30=mysql_5_7_30
            mysql/mysql-server:5.7.29-1.1.15=mysql_5_7_29 mysql/mysql-server:5.7.18=mysql_5_7_18 mysql/mysql-server:5.7.17=mysql_5_7_17
            mysql/mysql-server:5.6.51=mysql_5_6_51
            mysql/mysql-server:5.6.50=mysql_5_6_50 mysql/mysql-server:5.6.49=mysql_5_6_49 mysql/mysql-server:5.6.48=mysql_5_6_48
            mysql/mysql-server:5.6.47-1.1.15=mysql_5_6_47  mysql/mysql-server:5.6.46-1.1.13=mysql_5_6_46 mysql/mysql-server:5.6.45-1.1.12=mysql_5_6_45 mysql/mysql-server:5.6.44-1.1.11=mysql_5_6_44 mysql/mysql-server:5.6.43-1.1.10=mysql_5_6_43 mysql/mysql-server:5.6.42-1.1.8=mysql_5_6_42  mysql/mysql-server:5.6.41-1.1.7=mysql_5_6_41  mysql/mysql-server:5.6.40-1.1.5=mysql_5_6_40
	    mysql/mysql-server:5.6.39-1.1.3=mysql_5_6_39  mysql/mysql-server:5.6.38-1.1.2=mysql_5_6_38  mysql/mysql-server:5.6.37-1.1.1=mysql_5_6_37
            mysql/mysql-server:5.6.36=mysql_5_6_36  mysql/mysql-server:5.6.35=mysql_5_6_35 mysql/mysql-server:5.6.23=mysql_5_6_23"
SOME_MARIA="mariadb:10.6.11=maria_10_5_11 mariadb:10.6.10=maria_10_5_10 mariadb:10.6.9=maria_10_5_9   mariadb:10.6.8=maria_10_5_8
	    mariadb:10.6.7=maria_10_5_7   mariadb:10.6.6=maria_10_5_6   mariadb:10.6.5=maria_10_5_5   mariadb:10.6.4=maria_10_5_4
	    mariadb:10.5.11=maria_10_5_11 mariadb:10.5.10=maria_10_5_10 mariadb:10.5.9=maria_10_5_9   mariadb:10.5.8=maria_10_5_8
	    mariadb:10.5.7=maria_10_5_7   mariadb:10.5.6=maria_10_5_6   mariadb:10.5.5=maria_10_5_5   mariadb:10.5.4=maria_10_5_4
            mariadb:10.4.27=maria_10_4_27 mariadb:10.4.26=maria_10_4_26 mariadb:10.4.25=maria_10_4_25 mariadb:10.4.24=maria_10_4_24
	                                  mariadb:10.4.22=maria_10_4_22 mariadb:10.4.21=maria_10_4_21 mariadb:10.4.20=maria_10_4_20
            mariadb:10.4.19=maria_10_4_19 mariadb:10.4.18=maria_10_4_18 mariadb:10.4.17=maria_10_4_17 mariadb:10.4.16=maria_10_4_16
            mariadb:10.4.15=maria_10_4_15 mariadb:10.4.14=maria_10_4_14 mariadb:10.4.13=maria_10_4_13 mariadb:10.4.12=maria_10_4_12
	    mariadb:10.3.22=maria_10_3_22 mariadb:10.2.31=maria_10_2_31 mariadb:10.1.44=maria_10_1_44 mariadb:10.1.22=maria_10_1_22 mariadb:10.1.11=maria_10_1_11"
SOME_PERCO="                                           percona/percona-server:8.0.30=perco_8_0_30
	    percona/percona-server:8.0.28=perco_8_0_28 percona/percona-server:8.0.27-18=perco_8_0_27 percona/percona-server:8.0.26=perco_8_0_26
	    percona/percona-server:8.0.25=perco_8_0_25                                               percona/percona-server:8.0.23=perco_8_0_23
	    percona/percona-server:8.0.22=perco_8_0_22 percona/percona-server:8.0.21=perco_8_0_21    percona/percona-server:8.0.20=perco_8_0_20
	    percona/percona-server:8.0.19=perco_8_0_19
	    percona:ps-8.0.18-9=perco_8_0_18 percona/percona-server:8.0.13=perco_8_0_13
            percona/percona-server:5.7.40=perco_5_7_40 percona/percona-server:5.7.39=perco_5_7_39
            percona/percona-server:5.7.38=perco_5_7_38 percona/percona-server:5.7.37-40=perco_5_7_37 percona/percona-server:5.7.36=perco_5_7_36
            percona:ps-5.7.35=perco_5_7_35 percona:5.7.34=perco_5_7_34 percona:5.7.33=perco_5_7_33
            percona:ps-5.7.32=perco_5_7_32 percona:5.7.31=perco_5_7_31 percona:5.7.30=perco_5_7_30
            percona:ps-5.7.29=perco_5_7_29 percona:5.7.18=perco_5_7_18 percona:5.7.17=perco_5_7_17
            percona:ps-5.6.51=perco_5_6_51
            percona:ps-5.6.50=perco_5_6_50 percona:5.6.49=perco_5_6_49 percona:5.6.48=perco_5_6_28
            percona:ps-5.6.47=perco_5_6_47 percona:5.6.36=perco_5_6_36 percona:5.6.35=perco_5_6_35"
#
BUG_KO="mysql/mysql-server:5.6.35=mysql_5_6_35 mysql/mysql-server:5.7.17=mysql_5_7_17 percona:5.6.35=perco_5_6_35 percona:5.7.17=perco_5_7_17"
BUG_OK="mysql/mysql-server:5.6.36=mysql_5_6_36 mysql/mysql-server:5.7.18=mysql_5_7_18 percona:5.6.36=perco_5_6_36 percona:5.7.18=perco_5_7_18 mysql/mysql-server:5.7.29-1.1.15=mysql_5_7_29 percona:ps-5.7.29=perco_5_7_29 mysql/mysql-server:5.6.47-1.1.15=mysql_5_6_47 percona:ps-5.6.47=perco_5_6_47"
#
VERSION="case2"
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

                docker run --name ${NAM} -e MYSQL_ROOT_PASSWORD=test1234 -d ${IMG} >/tmp/run_${NAM}_${VERSION}.log 2>&1 || exit 1
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



