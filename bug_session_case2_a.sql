START TRANSACTION ;
system touch /tmp/consistent_session_created ;

source bug_buggy_chunks.sql ;
select NOW();
select count(*) from test.bug_consistent_read ;
select count(*) from test.bug_consistent_read_feed ;
select NOW() as currenttime ,'Count is done' as msg \G

delimiter //
system while [ ! -f /tmp/buggy_test_before_done  ] ; do sleep 2 ; done ;  //
delimiter ;

select NOW() as currenttime ,'wait for B  is done' as msg \G
source bug_create_buggy.sql;
select NOW() as currenttime ,'insert extra row is done' as msg \G

system touch /tmp/buggy_chunk_created ;

delimiter //
system while [ ! -f /tmp/buggy_test_done  ] ; do sleep 2 ; done ;  //
delimiter ;


rollback ;
system touch /tmp/consistent_rollback_done ;


