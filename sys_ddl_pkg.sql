CREATE OR REPLACE package sys_ddl_pkg is

  -- Author  : Spencer
  -- Created : 2017/5/23 21:22:02
  -- Purpose : 生成alter语句

  /**
  *  根据传入的表名+列名+数据类型+列描述+操作类别
  *  生成alter语句
  *
  **/
  PROCEDURE generate_alter_sql(p_table_name       VARCHAR2,
                               p_new_table_name   VARCHAR2,
                               p_column_name      VARCHAR2,
                               p_column_data_type VARCHAR2,
                               p_comment          VARCHAR2,
                               p_category         VARCHAR2);

end sys_ddl_pkg;
/


CREATE OR REPLACE package body sys_ddl_pkg is

  g_category_add    CONSTANT VARCHAR2(100) := 'ADD';
  g_category_modify CONSTANT VARCHAR2(100) := 'MODIFY';
  g_category_drop   CONSTANT VARCHAR2(100) := 'DROP';
  g_category_rename CONSTANT VARCHAR2(100) := 'RENAME';

  /**
  *  根据传入的表名+列名+数据类型+列描述+操作类别
  *  生成alter语句
  *
  **/
  PROCEDURE generate_alter_sql(p_table_name       VARCHAR2,
                               p_new_table_name   VARCHAR2,
                               p_column_name      VARCHAR2,
                               p_column_data_type VARCHAR2,
                               p_comment          VARCHAR2,
                               p_category         VARCHAR2) IS
    v_sql         VARCHAR2(32676) := 'ALTER TABLE ';
    v_comment_sql VARCHAR2(32676) := 'COMMENT ON ';
    v_is          VARCHAR2(2) := 'IS';
    v_to          VARCHAR2(2) := 'TO';
    v_quote_l     VARCHAR2(5) := '''';
    v_quote_r     VARCHAR2(5) := '''';
  BEGIN
    IF p_category = g_category_add THEN
      v_sql := v_sql || p_table_name || ' ' || g_category_add || ' ' ||
               p_column_name || ' ' || p_column_data_type;
      IF p_comment IS NOT NULL THEN
        v_comment_sql := v_comment_sql || p_table_name || '.' ||
                         p_column_name || v_is || ' ' || v_quote_l ||
                         p_comment || v_quote_r;
      END IF;
      dbms_output.put_line('alter add column sql');
      dbms_output.put_line(v_sql);
      dbms_output.put_line(v_comment_sql);
    ELSIF p_category = g_category_modify THEN
      v_sql := v_sql || p_table_name || ' ' || g_category_modify || ' ' ||
               p_column_name || ' ' || p_column_data_type;
      IF p_comment IS NOT NULL THEN
        v_comment_sql := v_comment_sql || p_table_name || '.' ||
                         p_column_name || v_is || ' ' || v_quote_l ||
                         p_comment || v_quote_r;
      END IF;
      dbms_output.put_line('alter modify column sql');
      dbms_output.put_line(v_sql);
      dbms_output.put_line(v_comment_sql);
    ELSIF p_category = g_category_drop THEN
      v_sql := v_sql || p_table_name || ' ' || g_category_drop || ' ' ||
               p_column_name;
    
      dbms_output.put_line('alter drop column sql');
      dbms_output.put_line(v_sql);
    ELSIF p_category = g_category_rename THEN
      v_sql := v_sql || p_table_name || ' ' || g_category_rename || ' ' || v_to ||
               p_new_table_name;
    
      dbms_output.put_line('alter rename table name sql');
      dbms_output.put_line(v_sql);
    ELSE
      dbms_output.put_line('操作类别不能识别，请确认！');
    END IF;
  END generate_alter_sql;
end sys_ddl_pkg;

/
