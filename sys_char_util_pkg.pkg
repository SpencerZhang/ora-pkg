create or replace package sys_char_util_pkg is

  -- Author  : Spencer
  -- Created : 2016/9/7 10:23:45
  -- Purpose : 替换参数里的特殊符号

  FUNCTION replace_spaces(p_args VARCHAR2) RETURN VARCHAR2;
  FUNCTION replace_enter(p_args VARCHAR2) RETURN VARCHAR2;
  FUNCTION replace_and(p_args VARCHAR2) RETURN VARCHAR2;
  FUNCTION get_ascii(p_args VARCHAR2) RETURN VARCHAR2;
  FUNCTION ascii_to_chr(p_args VARCHAR2) RETURN VARCHAR2;
  FUNCTION chr_to_ascii(p_args VARCHAR2) RETURN VARCHAR2;
end sys_char_util_pkg;
/
create or replace package body sys_char_util_pkg IS

  function replace_spaces(p_args VARCHAR2) return VARCHAR2 IS
  BEGIN
    --替换空格符
    RETURN(replace(p_args, CHR(32), ''));
  END replace_spaces;

  FUNCTION replace_enter(p_args VARCHAR2) RETURN VARCHAR2 IS
  BEGIN
    --替换回车符
    RETURN(replace(p_args, CHR(10), ''));
  END replace_enter;

  FUNCTION replace_and(p_args VARCHAR2) RETURN VARCHAR2 IS
  BEGIN
    --替换&符
    RETURN(replace(p_args, '&', CHR(38)));
  END replace_and;

  FUNCTION get_ascii(p_args VARCHAR2) RETURN VARCHAR2 IS
  BEGIN
    RETURN(ASCII(p_args));
  EXCEPTION
    WHEN OTHERS then
      RETURN('发生异常，参数：' || p_args);
  END get_ascii;

  --返回CHR
  FUNCTION ascii_to_chr(p_args VARCHAR2) RETURN VARCHAR2 IS
  BEGIN
    RETURN('CHR(' || ASCII(p_args) || ')');
  EXCEPTION
    WHEN OTHERS then
      RETURN('发生异常，参数：' || p_args);
  END ascii_to_chr;

  --返回CHR对应的字符，参数传数字
  FUNCTION chr_to_ascii(p_args VARCHAR2) RETURN VARCHAR2 IS
  BEGIN
    RETURN(CHR(p_args));
  EXCEPTION
    WHEN OTHERS then
      RETURN('发生异常，参数可以调用get_ascii返回数据' );
  END chr_to_ascii;
end sys_char_util_pkg;
/
