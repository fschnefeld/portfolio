{% macro calculate_percentage(numerator, denominator) %}
    CASE
        WHEN {{ denominator }} = 0 THEN 0
        ELSE ({{ numerator }} / {{ denominator }}) * 100
    END
{% endmacro %}
