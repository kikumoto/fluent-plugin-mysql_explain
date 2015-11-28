# fluent-plugin-mysql_explain

A Fluent filter plugin to execute EXPLAIN in mysql for a sql specified by the key.

## Requirements

Fluentd >= v0.12

## Install

```shell
gem install fluent-plugin-mysql_explain
```

## Configuration Example

```conf
<filter tag.dummy.*>
  type mysql_explain
  host db.localhost
  port 3306
  database mydb
  username user
  password pass
  sql_key sql
  added_key explain
</filter>
```

### sample

record before filter

```
{
  "sql": "select user,host from user;"
}
```

record after filter

```
{
  "sql": "select user,host from user;",
  "explain": "*************************** 1. row ***************************\n           id: 1
  select_type: SIMPLE\n        table: user\n         type: index\npossible_keys: NULL\n          key: PRIMARY\n      key_len: 228\n          ref: NULL\n         rows: 576\n        Extra: Using index"
}
```


## Parameters

* host (required)

  RDBMS host or ip

* port

  RDBMS port. Default is nil which means to use the MySQL defaullt port.

* database (required)

  RDBMS database name

* username (required)

  RDBMS login user name

* password

  RDBMS login password. Default is empty string.

* sql_key

  The key which is used to specify the explained sql in the record. Default is `sql`.

* added_key

  The key which was added to new record that holds the explained results. Default is `explain`.

## Copyright

Copyright (c) 2015 Takahiro Kikumoto. See [LICENSE](LICENSE) for details.
