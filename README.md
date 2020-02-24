# consistent-read-mysql-bug

This is a dataset to demonstrate a very serious bug that reveal , lack of ISOLATION between session .

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


open a session A and source `bug_session_a.sql`

open a session B and source `bug_session_b.sql`

both scripts will use /tmp/ for	creating files to sync .

## step by step process

### method 1

the writer will insert data with auto-commit
a reader will open a session and start a transaction

step by step :

1. start a session A
2. execute QUERY_COUNT must return 2000
3. start a session B
4. start a transaction with BEGIN
5. check your isolation level , by SELECT @@SESSION.tx_isolation ; must be REPEATABLE-READ
5. execute QUERY_COUNT must return 2000
6. switch to session A
7. execute INSERT_DATA_FROM_FEED ( source bug_create_buggy.sql )
8. wait for completion
9. switch to session B
10. execute QUERY_COUNT must return 2000 , but because of the bug it return 1706 why ?

### method 2

the writer will open a session , and start a transaction
insert data and rollback
a reader will open a regular session

step by step :

1. start a session A
2. start a TRANSACTION with BEGIN
3. execute QUERY_COUNT must return 2000
4. check your isolation level , by SELECT @@SESSION.tx_isolation ; must be REPEATABLE-READ
5. start a session B
5. execute QUERY_COUNT must return 2000
6. switch to session A
7. execute INSERT_DATA_FROM_FEED ( source bug_create_buggy.sql )
8. wait for completion ( don't commit )
9. switch to session B
10. execute QUERY_COUNT must return 2000 , but because of the bug it return 1706 why ?
11. switch to session A
12. rollback
13. wait for completion of rollback
14. switch to session B
15. execute QUERY_COUNT return 2000


## Why this a bug

### method 1 

step 10 is a bug because my select by commit made after my first SELECT

justification in https://dev.mysql.com/doc/refman/5.7/en/innodb-consistent-read.html

> Suppose that you are running in the default REPEATABLE READ isolation level. When you issue a consistent read (that is, an ordinary SELECT statement),
> InnoDB gives your transaction a timepoint according to which your query sees the database.
> If another transaction deletes a row and commits after your timepoint was assigned, you do not see the row as having been deleted. Inserts and updates are treated similarly.

### method 2

step 10 is a bug because concurent insert was not committed , why my select return less data

and at step 15 after the rollback , the query return now 2000


