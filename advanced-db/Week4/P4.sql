SET SERVEROUTPUT ON
SET linesize 120
SET pagesize 100

ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MM-YYYY';

BEGIN
    DBMS_OUTPUT.PUT_LINE(LPAD('Hello',100,'*'));
    DBMS_OUTPUT.PUT_LINE(CHR(10));
    DBMS_OUTPUT.PUT_LINE(RPAD('Hello', 100, '='));
END;
/

CREATE OR REPLACE PROCEDURE prc_show_product_by_id (v_code IN VARCHAR) IS
 v_prodCode products.productCode%TYPE;
 v_prodName products.productName%TYPE;
 v_prodVendor products.productVendor%TYPE;
 v_qty products.quantityInStock%TYPE;
 v_buyPrice products.buyPrice%TYPE;

begin
    select productCode, productName, productVendor, quantityInStock, buyPrice 
    INTO v_prodCode, v_prodName, v_prodVendor, v_qty, v_buyPrice
    FROM products
    WHERE productCode = v_code;


    DBMS_OUTPUT.PUT_LINE(LPAD('=',100,'='));
    DBMS_OUTPUT.PUT_LINE(CHR(10));
    DBMS_OUTPUT.PUT_LINE('Product supply by vendor: ' || v_prodVendor);
    DBMS_OUTPUT.PUT_LINE(CHR(10));
    DBMS_OUTPUT.PUT_LINE(RPAD('=',100,'='));
    DBMS_OUTPUT.PUT_LINE(RPAD('Code', 10, ' ') || ' ' ||
                         RPAD('Product Name', 40, ' ')|| ' '||
                         RPAD('Quantity', 10, ' ')||
                         RPAD('Buy Price', 15, ' '));

    DBMS_OUTPUT.PUT_LINE(RPAD('=',100,'='));

    DBMS_OUTPUT.PUT_LINE(RPAD(v_prodCode, 10, ' ') || ' ' ||
                         RPAD(v_prodName, 40, ' ')|| ' '||
                         RPAD(v_qty, 10, ' ')||
                         RPAD(TO_CHAR(v_buyPrice, '$9,999.99'), 15, ' '));

    DBMS_OUTPUT.PUT_LINE(RPAD('=',44,'=') || RPAD('End of File', 56, '='));

    exception
      when no_data_found then
        DBMS_OUTPUT.PUT_LINE('No such product: ' || v_code);
end;
/

/* EXEC prc_show_product_by_id('S10_1678')    */

CREATE OR REPLACE PROCEDURE prc_show_product_by_vendorSC1 (v_vendor IN VARCHAR) IS
 v_prodCode products.productCode%TYPE;
 v_prodName products.productName%TYPE;
 v_prodVendor products.productVendor%TYPE;
 v_qty products.quantityInStock%TYPE;
 v_buyPrice products.buyPrice%TYPE;

/* How many row of output will be display for loop in nutshell 
 just imagine this part is like you select the table , and then your assign the cursor to the first row
*/
CURSOR prodCursor IS 
    select productCode, productName, quantityInStock, buyPrice 
    FROM products
    WHERE productVendor = v_vendor;

begin

    DBMS_OUTPUT.PUT_LINE(LPAD('=',100,'='));
    DBMS_OUTPUT.PUT_LINE(CHR(10));
    DBMS_OUTPUT.PUT_LINE('Product supply by vendor: ' || v_vendor);
    DBMS_OUTPUT.PUT_LINE(CHR(10));
    DBMS_OUTPUT.PUT_LINE(RPAD('=',100,'='));
    DBMS_OUTPUT.PUT_LINE(RPAD('Code', 10, ' ') || ' ' ||
                         RPAD('Product Name', 40, ' ')|| ' '||
                         RPAD('Quantity', 10, ' ')||
                         RPAD('Buy Price', 15, ' '));

    DBMS_OUTPUT.PUT_LINE(RPAD('=',100,'='));

    /*This part is the part that we start get the value from the cursor**/
    OPEN prodCursor;
    LOOP 
    /* Assign the value that we get from the cursor into the variables*/
    /* Validate the vendor is valid (if there never any record from the query then we can know the vendor is invalid)*/
    FETCH prodCursor INTO v_prodCode, v_prodName,v_qty, v_buyPrice;
    IF(prodCursor%ROWCOUNT = 0) THEN
     DBMS_OUTPUT.PUT_LINE('No such  product vendor' || v_vendor);
    END IF;
    /*Exit condition for the cursor (when the cursor reach to the end which is NOTFOUND)*/
    EXIT WHEN prodCursor%NOTFOUND;

    DBMS_OUTPUT.PUT_LINE(RPAD(v_prodCode, 10, ' ') || ' ' ||
                         RPAD(v_prodName, 40, ' ')|| ' '||
                         RPAD(v_qty, 10, ' ')||
                         RPAD(TO_CHAR(v_buyPrice, '$9,999.99'), 15, ' '));

    END LOOP;
    DBMS_OUTPUT.PUT_LINE(RPAD('=',100,'='));
    DBMS_OUTPUT.PUT_LINE('Total number of products: '|| prodCursor%ROWCOUNT);
    /* Close the cursor*/
    CLOSE prodCursor;

    DBMS_OUTPUT.PUT_LINE(RPAD('=',44,'=') || RPAD('End of File', 56, '='));
end;
/

/* EXEC prc_show_product_by_vendorSC1('Min Lin Diecast'); */

CREATE OR REPLACE PROCEDURE prc_show_product_by_vendorSC2 (v_vendor IN VARCHAR) IS

CURSOR prodCursor IS 
    select productCode, productName, quantityInStock, buyPrice 
    FROM products
    WHERE productVendor = v_vendor;

prodRec prodCursor%ROWTYPE;

begin

    DBMS_OUTPUT.PUT_LINE(LPAD('=',100,'='));
    DBMS_OUTPUT.PUT_LINE(CHR(10));
    DBMS_OUTPUT.PUT_LINE('Product supply by vendor: ' || v_vendor);
    DBMS_OUTPUT.PUT_LINE(CHR(10));
    DBMS_OUTPUT.PUT_LINE(RPAD('=',100,'='));
    DBMS_OUTPUT.PUT_LINE(RPAD('Code', 10, ' ') || ' ' ||
                         RPAD('Product Name', 40, ' ')|| ' '||
                         RPAD('Quantity', 10, ' ')||
                         RPAD('Buy Price', 15, ' '));

    DBMS_OUTPUT.PUT_LINE(RPAD('=',100,'='));

    /*This part is the part that we start get the value from the cursor**/
    OPEN prodCursor;
    LOOP 
    /* Assign the value that we get from the cursor into the variables*/
    /* Validate the vendor is valid (if there never any record from the query then we can know the vendor is invalid)*/
    FETCH prodCursor INTO prodRec;
    IF(prodCursor%ROWCOUNT = 0) THEN
     DBMS_OUTPUT.PUT_LINE('No such  product vendor' || v_vendor);
    END IF;
    /*Exit condition for the cursor (when the cursor reach to the end which is NOTFOUND)*/
    EXIT WHEN prodCursor%NOTFOUND;

    DBMS_OUTPUT.PUT_LINE(RPAD(prodRec.productCode, 10, ' ') || ' ' ||
                         RPAD(prodRec.productName, 40, ' ')|| ' '||
                         RPAD(prodRec.quantityInStock, 10, ' ')||
                         RPAD(TO_CHAR(prodRec.buyPrice, '$9,999.99'), 15, ' '));

    END LOOP;
    DBMS_OUTPUT.PUT_LINE(RPAD('=',100,'='));
    DBMS_OUTPUT.PUT_LINE('Total number of products: '|| prodCursor%ROWCOUNT);
    /* Close the cursor*/
    CLOSE prodCursor;

    DBMS_OUTPUT.PUT_LINE(RPAD('=',44,'=') || RPAD('End of File', 56, '='));
end;
/
/*EXEC prc_show_product_by_vendorSC2('Min Lin Diecast');*/
==================================================================================================================================

CREATE OR REPLACE PROCEDURE prc_show_product_by_vendorNC1 IS
 v_prodCode products.productCode%TYPE;
 v_prodName products.productName%TYPE;
 v_prodVendor products.productVendor%TYPE;
 v_qty products.quantityInStock%TYPE;
 v_buyPrice products.buyPrice%TYPE;
 v_subtotal NUMBER(11,2);
 v_grandTotal NUMBER (11,2);
 v_totalValue NUMBER (15,2);

CURSOR vendorCursor IS
    SELECT DISTINCT productVendor
    FROM products
    ORDER BY productVendor;

/* How many row of output will be display for loop in nutshell 
 just imagine this part is like you select the table , and then your assign the cursor to the first row
*/
CURSOR prodCursor IS 
    select productCode, productName, quantityInStock, buyPrice, quantityInStock * buyPrice AS Subtotal
    FROM products
    WHERE productVendor = v_prodVendor;

begin
    v_totalValue := 0;
    OPEN vendorCursor;
    LOOP
        FETCH vendorCursor INTO v_prodVendor;
        EXIT WHEN vendorCursor%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE(LPAD('=',100,'='));
        DBMS_OUTPUT.PUT_LINE(CHR(10));
        DBMS_OUTPUT.PUT_LINE('Product supply by vendor: ' || v_prodVendor);
        DBMS_OUTPUT.PUT_LINE(CHR(10));
        DBMS_OUTPUT.PUT_LINE(RPAD('=',100,'='));
        DBMS_OUTPUT.PUT_LINE(RPAD('Code', 10, ' ') || ' ' ||
                            RPAD('Product Name', 40, ' ')|| ' '||
                            RPAD('Quantity', 10, ' ')||
                            RPAD('Buy Price', 15, ' ')||
                            RPAD('     Subtotal', 20, ' '));

        DBMS_OUTPUT.PUT_LINE(RPAD('=',100,'='));

        /*This part is the part that we start get the value from the cursor**/
        OPEN prodCursor;
        v_grandTotal := 0;
        LOOP 

            /* Assign the value that we get from the cursor into the variables*/
            /* Validate the vendor is valid (if there never any record from the query then we can know the vendor is invalid)*/
            FETCH prodCursor INTO v_prodCode, v_prodName,v_qty, v_buyPrice, v_subtotal;
            IF(prodCursor%ROWCOUNT = 0) THEN
            DBMS_OUTPUT.PUT_LINE('No such  product vendor' || v_prodVendor);
            END IF;
            /*Exit condition for the cursor (when the cursor reach to the end which is NOTFOUND)*/
            EXIT WHEN prodCursor%NOTFOUND;

            v_grandTotal := v_grandTotal + v_subtotal;

            DBMS_OUTPUT.PUT_LINE(RPAD(v_prodCode, 10, ' ') || ' ' ||
                                RPAD(v_prodName, 40, ' ')|| ' '||
                                RPAD(v_qty, 10, ' ')||
                                RPAD(TO_CHAR(v_buyPrice, '$9,999.99'), 15, ' ')||
                                RPAD(TO_CHAR(v_subtotal, '$99,999,999.99'), 15, ' '));

        END LOOP;

        v_totalValue := v_totalValue + v_grandTotal;

        DBMS_OUTPUT.PUT_LINE(RPAD('=',100,'='));
        DBMS_OUTPUT.PUT_LINE('Total number of products: '|| prodCursor%ROWCOUNT);
        DBMS_OUTPUT.PUT_LINE('Grand Total: '|| TO_CHAR(v_grandTotal, '$99,999,999.99'));
        /* Close the cursor*/
        CLOSE prodCursor;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(RPAD('=',100,'='));
    DBMS_OUTPUT.PUT_LINE('Total number of vendors: '|| vendorCursor%ROWCOUNT);
    DBMS_OUTPUT.PUT_LINE('Total value: '|| TO_CHAR(v_totalValue, '$99,999,999.99'));
    CLOSE vendorCursor;
    DBMS_OUTPUT.PUT_LINE(RPAD('=',44,'=') || RPAD('End of File', 56, '='));
end;
/
/*exec prc_show_product_by_vendorNC1 */