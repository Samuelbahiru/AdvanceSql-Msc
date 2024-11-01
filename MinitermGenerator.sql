CREATE OR REPLACE PACKAGE Miniterm_Pkg IS
    TYPE PredicateList IS TABLE OF VARCHAR2
(100);

    PROCEDURE Generate_Miniterms
(predicates IN PredicateList, miniterms OUT SYS_REFCURSOR);
END Miniterm_Pkg;


CREATE OR REPLACE PACKAGE BODY Miniterm_Pkg IS
    PROCEDURE Generate_Miniterms
(predicates IN PredicateList, miniterms OUT SYS_REFCURSOR) IS
        result SYS_REFCURSOR;
        miniterm VARCHAR2
(4000);
        combination_count NUMBER := 2 ** predicates.COUNT;
BEGIN
    OPEN result
    FOR
    SELECT *
    FROM (
                SELECT LEVEL AS combination_id
        FROM dual CONNECT BY LEVEL
    <= combination_count
            );

LOOP
FETCH result
INTO combination_id;
            EXIT WHEN result%NOTFOUND;
            
            miniterm := '';
            
            FOR i IN 1 .. predicates.COUNT LOOP
IF BITAND(combination_id - 1, POWER(2, i - 1)) > 0 THEN
                    miniterm := miniterm || predicates
(i) || ' AND ';
                ELSE
                    miniterm := miniterm || 'NOT ' || predicates
(i) || ' AND ';
END
IF;
            END LOOP;

            -- Remove trailing ' AND ' and insert the generated miniterm
            miniterm := RTRIM
(miniterm, ' AND ');
            DBMS_OUTPUT.PUT_LINE
(miniterm);
END LOOP;

CLOSE result;
END Generate_Miniterms;
END Miniterm_Pkg;
/
