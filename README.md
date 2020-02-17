# perco-mysql-bug

BEWARE you must	use **git lfs**	instead	of **git**

you NEED to use `git lfs clone https://github.com/ErwanMAS/perco-mysql-bug.git`

git lfs is for large objects ( in this repo , mysqldump/ )


## populate 2 tables with 2 mysql dumps

```
bzcat dump_bug_consistent_read.bz2       | mysql test
bzcat dump_bug_consistent_read_feed.bz2  | mysql test
```

## full process with the 2 helper scripts


open a session A and source `bug_session_a.sql`

open a session B and source `bug_session_b.sql`

both scripts will use /tmp/ for	creating files to sync .


## manual process step by step 

1. open a session A

`source bug_buggy_chunks.sql ; `

must return always a rounded number ( 2000 , 5000 , 10000 , 15000 , 20000 ) 

2. open a session B

start a consistent snapshot with

`START TRANSACTION WITH CONSISTENT SNAPSHOT ;`

`source bug_buggy_chunks.sql ; `

must return always a rounded number ( 2000 , 5000 , 10000 , 15000 , 20000 ) 


3. now back on session A

source file `bug_create_buggy.sql`

this file will pouplate `bug_consistent_read` with some row of `bug_consistent_read_feed`

when is done

4. back to session B

run again the script and you will see many values not rounded  

`source bug_buggy_chunks.sql ; `

