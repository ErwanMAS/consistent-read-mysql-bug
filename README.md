# consistent-read-mysql-bug

This is a dataset to demonstrate a very critical bug with the mysql transaction isolation .

Case 1

During a transaction a range query select can have his result truncated , by inserts committed after the begin of the transaction

Case 2

A range query can have his result truncated , by inserts that are not commited

this regression appear between version version 5.6.35 and version 5.6.36 and 5.6.47 has still the bug

this regression appear between version version 5.7.17 and version 5.7.18 and 5.7.29 has still the bug


## Requirements

2 tables must be populated with the current mysqldumps ( from https://github.com/ErwanMAS/consistent-read-mysql-bug/tree/master/mysqldump )

i will reference the first query of bug_buggy_chunk.sql as QUERY_COUNT ( https://github.com/ErwanMAS/consistent-read-mysql-bug/blob/master/bug_buggy_chunks.sql )

i will reference the file bug_create_buggy.sql as INSERT_DATA_FROM_FEED ( https://github.com/ErwanMAS/consistent-read-mysql-bug/blob/master/bug_create_buggy.sql )


## Bug reports

  https://jira.percona.com/browse/PS-6855

  https://bugs.mysql.com/bug.php?id=98642


## Videos

i created some videos videos some the full process, you can see at the end the issue

 1. [video that exhibit the bug with a reader transaction ](videos/bug_98642_method1.mp4) videos/bug_98642_method1.mp4
 2. [video that exhibit the bug with a writer transaction ](videos/bug_98642_method2.mp4) videos/bug_98642_method2.mp4

## populate 2 tables with 2 mysql dumps

```
bzcat dump_bug_consistent_read.bz2       | mysql test
bzcat dump_bug_consistent_read_feed.bz2  | mysql test
```

## full automated tests  with the 2 helper scripts

### Case 1

open a session A and source `bug_session_case1_a.sql`

open a session B and source `bug_session_case1_b.sql`

both scripts will use /tmp/ for	creating files to sync .

### Case 2

open a session A and source `bug_session_case2_a.sql`

open a session B and source `bug_session_case2_b.sql`

both scripts will use /tmp/ for	creating files to sync .

## manual process step by step for case 1

1. open a session A

`source bug_buggy_chunks.sql ; `

must return always a rounded number ( 2000 , 5000 , 10000 , 15000 , 20000 )

2. open a session B

start a transaction with

`START TRANSACTION ;`

`source bug_buggy_chunks.sql ; `

must return always a rounded number ( 2000 , 5000 , 10000 , 15000 , 20000 )

3. now back on session A

source file `bug_create_buggy.sql`

this file will pouplate `bug_consistent_read` with some row of `bug_consistent_read_feed`

when is done

4. back to session B

run again the script and you will see many values not rounded

`source bug_buggy_chunks.sql ; `


## manual process step by step for case 2

1. open a session A

start a transaction with

`START TRANSACTION ;`

`source bug_buggy_chunks.sql ; `

must return always a rounded number ( 2000 , 5000 , 10000 , 15000 , 20000 )

2. open a session B

`source bug_buggy_chunks.sql ; `

must return always a rounded number ( 2000 , 5000 , 10000 , 15000 , 20000 )

3. now back on session A

source file `bug_create_buggy.sql`

this file will pouplate `bug_consistent_read` with some row of `bug_consistent_read_feed`

when is done

4. back to session B

run again the script and you will see many values not rounded

`source bug_buggy_chunks.sql ; `

5. back to session A

rollback inserts .

`rollback ;`

wait for completion

6. open a session B

`source bug_buggy_chunks.sql ; `

now the value are back to orignal value , a rounded number ( 2000 , 5000 , 10000 , 15000 , 20000 )



