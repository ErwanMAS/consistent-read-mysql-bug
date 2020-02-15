
select NOW() ;
source /tmp/bug_create_buggy.sql;
select NOW() ;
system touch /tmp/buggy_chunk_created ;
