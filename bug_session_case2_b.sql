delimiter //
system while [ ! -f /tmp/consistent_session_created  ] ; do sleep 2 ; done ;  //
delimiter ;

source bug_buggy_chunks.sql ;
select NOW();
select count(*) from test.bug_consistent_read ;
select count(*) from test.bug_consistent_read_feed ;
select NOW() as currenttime ,'Count is done' as msg \G

system touch /tmp/buggy_test_before_done ;

delimiter //
system while [ ! -f /tmp/buggy_chunk_created  ] ; do sleep 2 ; done ;  //
delimiter ;

select NOW() as currenttime ,'wait for A insert is done' as msg \G
source bug_buggy_chunks.sql ;

system touch /tmp/buggy_test_done ;

delimiter //
system while [ ! -f /tmp/consistent_rollback_done  ] ; do sleep 2 ; done ;  //
delimiter ;

select NOW() as currenttime ,'wait for A rollback is done' as msg \G
source bug_buggy_chunks.sql ;


