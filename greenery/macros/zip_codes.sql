{% test zip_codes(model, column_name) %}


   select *
   from {{ model }}
   where length(({{ column_name }}::text)) = 5


{% endtest %}