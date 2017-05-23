# ora-pkg

## ascii & chr 转换 pkg

## 例子 / example

```PL/SQL
declare
  v_chr varchar2(30);
begin
  v_chr := sys_char_util_pkg.ascii_to_chr(" ");
end;
```

## 生成alter 语句

```PL/SQL
declare
begin
   sys_ddl_pkg.generate_alter_sql(p_table_name       => "tableName",
                               	  p_new_table_name   => "renameTableName",//可选
                               	  p_column_name      => "columnName",
                               	  p_column_data_type => "NUMBER",//可选
                               	  p_comment          => "columnDesc",//可选
                                  p_category         => "ADD");
end;
```

## 开源协议 / License

[MIT](http://opensource.org/licenses/MIT)

Copyright (c) 2017 Spencer Chang
