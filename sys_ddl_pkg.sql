create or replace package sys_ddl_pkg is

  -- Author  : Spencer
  -- Created : 2017/5/23 9:22:02
  -- Purpose : 生成alter语句

  /**
  *  根据传入的表名+列名+数据类型+列描述+操作类别+是否立即执行
  *  生成alter语句
  *
  **/
  PROCEDURE generate_alter_sql(p_table_name       VARCHAR2,
                               p_new_table_name   VARCHAR2 DEFAULT NULL,
                               p_column_name      VARCHAR2 DEFAULT NULL,
                               p_column_data_type VARCHAR2 DEFAULT NULL,
                               p_comment          VARCHAR2 DEFAULT NULL,
                               p_category         VARCHAR2,
                               p_execute_flag     VARCHAR2);

  /**
  *  修改列数据类型
  *
  **/
  PROCEDURE modify_column_dataType(p_table_name       VARCHAR2,
                                   p_column_name      VARCHAR2 DEFAULT NULL,
                                   p_column_data_type VARCHAR2 DEFAULT NULL,
                                   p_execute_flag     VARCHAR2);
end sys_ddl_pkg;
/
create or replace package body sys_ddl_pkg is

  g_category_add    CONSTANT VARCHAR2(100) := 'ADD';
  g_category_modify CONSTANT VARCHAR2(100) := 'MODIFY';
  g_category_drop   CONSTANT VARCHAR2(100) := 'DROP';
  g_category_rename CONSTANT VARCHAR2(100) := 'RENAME';

  PROCEDURE execute_sql(p_sql VARCHAR2) IS
    PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN
    --执行生成的sql语句
    execute immediate (p_sql);
    COMMIT;
  END execute_sql;

  /**
  *  根据传入的表名+列名+数据类型+列描述+操作类别
  *  生成alter语句
  *
  **/
  PROCEDURE generate_alter_sql(p_table_name       VARCHAR2,
                               p_new_table_name   VARCHAR2 DEFAULT NULL,
                               p_column_name      VARCHAR2 DEFAULT NULL,
                               p_column_data_type VARCHAR2 DEFAULT NULL,
                               p_comment          VARCHAR2 DEFAULT NULL,
                               p_category         VARCHAR2,
                               p_execute_flag     VARCHAR2) IS
    v_sql         VARCHAR2(32676) := 'ALTER TABLE ';
    v_comment_sql VARCHAR2(32676) := 'COMMENT ON COLUMN ';
    v_is          VARCHAR2(2) := 'IS';
    v_to          VARCHAR2(2) := 'TO';
    v_quote_l     VARCHAR2(5) := '''';
    v_quote_r     VARCHAR2(5) := '''';
  BEGIN
    IF p_category = g_category_add THEN
      v_sql := v_sql || p_table_name || ' ' || g_category_add || ' ' ||
               p_column_name || ' ' || p_column_data_type || ';';
      IF p_comment IS NOT NULL THEN
        v_comment_sql := v_comment_sql || p_table_name || '.' ||
                         p_column_name || ' ' || v_is || ' ' || v_quote_l ||
                         p_comment || v_quote_r || ';';
      END IF;
      dbms_output.put_line('alter add column sql');
      dbms_output.put_line(chr(13));
      dbms_output.put_line(v_sql);
      dbms_output.put_line(v_comment_sql);
    ELSIF p_category = g_category_modify THEN
      v_sql := v_sql || p_table_name || ' ' || g_category_modify || ' ' ||
               p_column_name || ' ' || p_column_data_type || ';';
      IF p_comment IS NOT NULL THEN
        v_comment_sql := v_comment_sql || p_table_name || '.' ||
                         p_column_name || ' ' || v_is || ' ' || v_quote_l ||
                         p_comment || v_quote_r || ';';
      END IF;
      dbms_output.put_line('alter modify column sql');
      dbms_output.put_line(chr(13));
      dbms_output.put_line(v_sql);
      dbms_output.put_line(v_comment_sql);
    ELSIF p_category = g_category_drop THEN
      v_sql := v_sql || p_table_name || ' ' || g_category_drop || ' ' ||
               p_column_name || ';';
    
      dbms_output.put_line('alter drop column sql');
      dbms_output.put_line(chr(13));
      dbms_output.put_line(v_sql);
    ELSIF p_category = g_category_rename THEN
      v_sql := v_sql || p_table_name || ' ' || g_category_rename || ' ' || v_to || ' ' ||
               p_new_table_name || ';';
    
      dbms_output.put_line('alter rename table name sql');
      dbms_output.put_line(chr(13));
      dbms_output.put_line(v_sql);
    ELSE
      dbms_output.put_line('操作类别不能识别，请确认！');
    END IF;
  
    IF p_execute_flag = 'Y' THEN
      --执行生成的sql语句
      execute_sql(p_sql => v_sql);
    END IF;
  END generate_alter_sql;

  /**
  *  修改列数据类型
  *
  **/
  PROCEDURE modify_column_dataType(p_table_name       VARCHAR2,
                                   p_column_name      VARCHAR2 DEFAULT NULL,
                                   p_column_data_type VARCHAR2 DEFAULT NULL,
                                   p_execute_flag     VARCHAR2) IS
    v_sql_prefix VARCHAR2(32676) := 'ALTER TABLE ';
    v_sql        VARCHAR2(32676);
    v_update_sql VARCHAR2(32676);
  BEGIN
    --setp1 新增临时列
    v_sql := v_sql_prefix || p_table_name || ' ' || g_category_add || ' ' ||
             'tmp_column' || ' ' || 'varchar2(2000)' || ';';
    dbms_output.put_line('alter add column sql');
    dbms_output.put_line(chr(13));
    dbms_output.put_line(v_sql);
    dbms_output.put_line(chr(13));
  
    IF p_execute_flag = 'Y' THEN
      --执行生成的sql语句
      execute_sql(p_sql => v_sql);
    END IF;
  
    --setp2 存储被修改列数据
    v_update_sql := 'UPDATE' || ' ' || p_table_name || ' set tmp_column = ' ||
                    p_column_name || ';';
    dbms_output.put_line('alter update column data sql');
    dbms_output.put_line(chr(13));
    dbms_output.put_line(v_update_sql);
    dbms_output.put_line(chr(13));
  
    IF p_execute_flag = 'Y' THEN
      --执行生成的sql语句
      execute_sql(p_sql => v_update_sql);
    END IF;
  
    --setp3 修改列数据类型
    v_sql := NULL;
    v_sql := v_sql_prefix || p_table_name || ' ' || g_category_modify || ' ' ||
             p_column_name || ' ' || p_column_data_type || ';';
    dbms_output.put_line('alter modify column sql');
    dbms_output.put_line(chr(13));
    dbms_output.put_line(v_sql);
    dbms_output.put_line(chr(13));
  
    IF p_execute_flag = 'Y' THEN
      --执行生成的sql语句
      execute_sql(p_sql => v_sql);
    END IF;
  
    --setp4 还原被修改列数据 
    v_update_sql := NULL;
    v_update_sql := 'UPDATE' || ' ' || p_table_name || ' set ' ||
                    p_column_name || ' = tmp_column ' || ';';
    dbms_output.put_line('alter update column data sql');
    dbms_output.put_line(chr(13));
    dbms_output.put_line(v_update_sql);
    dbms_output.put_line(chr(13));
  
    IF p_execute_flag = 'Y' THEN
      --执行生成的sql语句
      execute_sql(p_sql => v_update_sql);
    END IF;
  
    --setp5 删除临时列
    v_sql := NULL;
    v_sql := v_sql_prefix || p_table_name || ' ' || g_category_drop || ' ' ||
             'tmp_column' || ';';
  
    dbms_output.put_line('alter drop column sql');
    dbms_output.put_line(chr(13));
    dbms_output.put_line(v_sql);
  
    IF p_execute_flag = 'Y' THEN
      --执行生成的sql语句
      execute_sql(p_sql => v_sql);
    END IF;
  
  END modify_column_dataType;
end sys_ddl_pkg;
/
