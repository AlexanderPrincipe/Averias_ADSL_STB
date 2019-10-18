USE PV_STC_COMISIONES
-------------------SMA_ADSL_2019.SQL-----------------

/*
 DROP PROCEDURE SMA_ADSL_STB_PROCEDURE
 DROP TABLE SMA_ADSL
 DROP TABLE SMA_STB
 DROP VIEW INF_ADSL
 DROP VIEW REIT_ADSL
 DROP VIEW REIT_STB
 DROP VIEW ADSL_FINAL
 DROP VIEW STB_FINAL
 DROP VIEW INF_STB
 DROP TABLE STB_FINAL
 DROP TABLE ADSL_FINAL
 */

CREATE PROCEDURE SMA_ADSL_STB_PROCEDURE @MES FLOAT, @ANIO FLOAT
AS

-- SE CREA LA TABLA SMA_ADSL CON LOS VALORES DE LA TABLA ADSL

-- DROP TABLE SMA_ADSL
SELECT * INTO SMA_ADSL FROM ADSL;
-- SE AGREGA LA COLUMNA
ALTER TABLE SMA_ADSL ADD CSEG VARCHAR(250);

-- SE COPIA A LA COLUMNA CSEG LOS VALORES DE LA COLUMNA CODSEG
UPDATE SMA_ADSL
SET CSEG = CODSEG;

-- ACTUALIZAR EL CAMPO CSEG DE LA TABLA SMA_ADSL
UPDATE SMA_ADSL
SET CSEG = 'E'
WHERE CSEG IN ('0','1','2','3','4','5','6','7')
AND MM_LIQ = @MES AND AA_LIQ = @ANIO;

-- SE AGREGA LA COLUMNA 'TELEFONO' A LA TABLA SMA_ADSL
ALTER TABLE SMA_ADSL ADD TELEFONO NVARCHAR(255);

-- DESPUES DE AGREGAR LA COLUMNA 'TELEFONO' A LA TABLA SMA_ADSL, SE ACTUALIZA LA COLUMNA TELEFONO PARA QUE TENGA EL VALOR 0
UPDATE SMA_ADSL
SET TELEFONO = 0
WHERE TELEFONO IS NULL;

---------------------UPDATE JOIN--------------------------
-- SE ACTUALIZA LA TABLA TELEFONO RELACIONANDO AL CAMPO COD_LIQ DE LA TABLA CODLIQ_ADSL_2017 CON LA CONDICION DE QUE EL MES SEA EL REQUERIDO
UPDATE A
SET A.TELEFONO = B.CLASIF_NUEVA
FROM SMA_ADSL A JOIN CODLIQ_ADSL_2017 B ON A.CODLIQ = B.COD_LIQ
WHERE A.MM_LIQ = @MES AND  A.AA_LIQ = @ANIO;

-- SE AGREGA LA COLUMNA MODRUT A LA TABLA SMA_ADSL
ALTER TABLE SMA_ADSL ADD MODRUT INT;

-- SE ACTUALIZA LA COLUMNA MODRUT RECIEN CREADA PARA QUE TENGA EL VALOR DE 0
UPDATE SMA_ADSL
SET MODRUT = 0
WHERE MODRUT IS NULL;

-- SE ACTUALIZA LA COLUMNA MODRUT RELACIONANDO EL CAMPO 'MDF' DE LA TABLA RUTEMPP
UPDATE A
SET A.MODRUT = 1
FROM SMA_ADSL A JOIN RUTEMPP B ON A.MDF = B.MDF
WHERE LEN(A.MDF) = 4
	AND (A.CSEG) = 'E'
	AND A.MM_LIQ = @MES
	AND A.AA_LIQ = @ANIO;

-- SE AGREGA LA COLUMNA INSMDF A LA TABLA SMA_ADSL
ALTER TABLE SMA_ADSL ADD INSMDF INT;

-- SE ACTUALIZA LA COLUMNA INSMDF RECIEN CREADA PARA QUE TENGA EL VALOR DE 0
UPDATE SMA_ADSL
SET INSMDF = 0
WHERE INSMDF IS NULL;
/*
-- SE CREO LA FUNCION TRIM() QUE ES LA COMBINACION DE 'LTRIM' Y 'RTRIM' QUE SIRVE PARA ELIMINAR ESPACIOS INNECESARIOS
create function TRIM(@data varchar(255)) returns varchar(255)
as
begin
  declare @str varchar(255)
  set @str = rtrim(ltrim(@data))
  return @str
end
*/

-- SE ACTUALIZA LA COLUMNA INSMDF RELACIONANDO CON LA TABLA MDF_INSOURCING2015
UPDATE A
SET INSMDF = 1
FROM SMA_ADSL A JOIN MDF_INSOURCING2015 B ON A.MDF = B.MDF
WHERE DBO.TRIM(A.CODLIQ) IN ('31','32','33','34')
	--AND B.SWITCH = '.T.'
	AND A.MM_LIQ = @MES
	AND A.AA_LIQ = @ANIO;

-- SE CREA LA COLUMNA MODARM EN LA TABLA SMA_ADSL
ALTER TABLE SMA_ADSL ADD MODARM INT;

-- SE ACTUALIZA LA COLUMNA MODRUT RECIEN CREADA PARA QUE TENGA EL VALOR DE 0
UPDATE SMA_ADSL
SET MODARM = 0
WHERE MODARM IS NULL;

-- SE ACTUALIZA LA COLUMNA MODARM RELACIONANDOLO CON LA TABLA MODARM
UPDATE A
SET MODARM = 1
FROM SMA_ADSL A JOIN MODARM B ON (A.MDF = B.MDF)
WHERE DBO.TRIM(A.CODLIQ) IN ('15','24')
	AND A.MM_LIQ = @MES
	AND A.AA_LIQ = @ANIO;

-- CODIGO GLORIA - VISUAL FOX PRO
-- SELECT * FROM 'd:\calc_averias\ACUM\2019\SMA_ADSL' GROUP BY AVERIA INTO TABLE 'd:\calc_averias\ACUM\2019\SMA_ADSL2'



--*********************************************************************************************
-------------------SMA_STB_2019.SQL------------------------------------------------------------
-- DROP TABLE SMA_STB
SELECT * INTO SMA_STB FROM STB;

ALTER TABLE SMA_STB ADD CSEG VARCHAR(255)

UPDATE SMA_STB
SET CSEG = CODSEG;

UPDATE SMA_STB
SET CSEG = 'E'
WHERE CODSEG IN ('00','01','02','03','04','05','06','07','0','1','2','3','4','5','6','7')
AND MM_LIQ = @MES
AND AA_LIQ = @ANIO;


ALTER TABLE SMA_STB ADD MODRUTAS INT

UPDATE SMA_STB
SET MODRUTAS = 0
WHERE MODRUTAS IS NULL;

UPDATE SMA_STB
SET MODRUTAS = 1
WHERE DBO.TRIM(ZONAL) = 'LIMA' AND CSEG = 'E' AND MM_LIQ = @MES AND AA_LIQ = @ANIO;
----------------------------------------------------------------------------------------

UPDATE A
SET A.MODRUTAS = 1
FROM SMA_STB A JOIN RUTEMPP B ON A.MDF = B.MDF
WHERE LEN(DBO.TRIM(TI_LIQN)) = 4
	AND CSEG = 'E'
	AND A.MM_LIQ = @MES
	AND A.AA_LIQ = @ANIO;
---------------------------------------------------------------------------------
ALTER TABLE SMA_STB ADD INS_MDF INT

UPDATE SMA_STB
SET INS_MDF = 0
WHERE INS_MDF IS NULL

UPDATE A
SET INS_MDF = 1
FROM SMA_STB A JOIN MDF_INSOURCING2015 B ON A.MDF = B.MDF
WHERE DBO.TRIM(TI_LIQN) IN ('31','32','33','34')
      AND SWITCH = 1
      AND A.MM_LIQ = @MES
	  AND A.AA_LIQ = @ANIO;

--------------------------------------------------------------------------------------------------------------------
ALTER TABLE SMA_STB ADD CLASIF NVARCHAR(255)

UPDATE SMA_STB
SET CLASIF = 0
WHERE CLASIF IS NULL


ALTER TABLE SMA_STB ALTER COLUMN TI_LIQN NVARCHAR(255)

UPDATE A
SET A.CLASIF = B.CLASIF
FROM SMA_STB A JOIN CODLIQ_STB_2017 B ON A.TI_LIQN = B.COD_LIQ
WHERE A.MM_LIQ = @MES
	  AND A.AA_LIQ = @ANIO;


SELECT * FROM SMA_STB
SELECT TI_LIQN, COUNT(*) FROM SMA_STB GROUP BY TI_LIQN HAVING COUNT(*) > 1 ORDER BY COUNT(*) DESC
SELECT COD_LIQ, COUNT(*) FROM CODLIQ_STB_2017 GROUP BY COD_LIQ HAVING COUNT(*) > 1 ORDER BY COUNT(*) DESC


--------------------------------------------------------------------------------
ALTER TABLE SMA_STB ADD MODARM INT

UPDATE SMA_STB
SET MODARM = 0
WHERE MODARM IS NULL;

UPDATE A
SET MODARM = 1
FROM SMA_STB A JOIN MODARM B ON A.MDF = B.MDF
WHERE  DBO.TRIM(A.TI_LIQN) IN ('15', '24')
	  AND A.MM_LIQ = @MES
	  AND A.AA_LIQ = @ANIO;

-- CODIGO GLORIA GROUP BY -- > VISUAL FOX PRO
--SELECT * FROM SMA_STB GROUP BY COD_UNICO INTO TABLE 'd:\calc_averias\ACUM\2019\SMA_STB4'

-- SE CREA LA VISTA ADSL_FINAL, ES EL RESULTADO FINAL DESPUES DE TODO EL PROCESO


--*********************************************************************************************
-------------------CALC_INF_ADSL_ACT.SQL------------------------------------------------------------

-- ELIMINAR LOS REGISTROS CON LOS CAMPOS DE CODSEG Y AREA QUE TENGAN LAS SIGUIENTES VARIABLES
DELETE FROM ICOBRE WHERE CODSEG IN ('0','00','1','2','3','4','5','6','7') AND AREA = 'L'

SELECT CODSEG, AREA FROM ICOBRE WHERE CODSEG = '8'

-- SELECT MONTH(FEJEPEX), COUNT(*) FROM DET_ALTAS GROUP BY MONTH(FEJEPEX) HAVING COUNT(*) > 1


--AGREGAR COLUMNAS A LA TABLA ICOBRE

/*
ALTER TABLE ICOBRE ADD grp_tipo NVARCHAR(250)
ALTER TABLE ICOBRE ADD clasif NVARCHAR(250)
ALTER TABLE ICOBRE ADD modrutas NVARCHAR(250)
ALTER TABLE ICOBRE ADD modarm NVARCHAR(250)
ALTER TABLE ICOBRE ADD insmdf NVARCHAR(250)
ALTER TABLE ICOBRE ADD deleqp NVARCHAR(250)
ALTER TABLE ICOBRE ADD microzonas NVARCHAR(250)
ALTER TABLE ICOBRE ADD MZ2 NVARCHAR(250)
*/

/*-----------------------------------------------------------------*/

/*CREACION DE LOS INDICES CMDF, TI_LIQN Y CO_UNICO
CREATE INDEX CMDF
ON ICOBRE_0719 (CMDF);

CREATE INDEX TI_LIQN
ON ICOBRE_0719 (TI_LIQN);

CREATE INDEX CO_UNICO
ON ICOBRE_0719 (CO_UNICO);
*/
/*-----------------------------------------------------------------*/

--REVISAR --> FROM ICOBRE A JOIN CODLIQ_ADSL_2017 B ON A.TI_LIQN = B.COD_LIQ
UPDATE A
SET A.CLASIF = B.CLASIF_NUEVA
FROM ICOBRE A JOIN CODLIQ_ADSL_2017 B ON A.TI_LIQN = B.COD_LIQ
WHERE A.TI_LIQN IS NOT NULL
	  AND DBO.TRIM(A.NEGOCIO) = 'ADSL'

/*-----------------------------------------------------------------*/

UPDATE A
SET A.MODRUTAS = 'X'
FROM ICOBRE A JOIN RUTEMPP B ON A.CMDF = B.MDF
WHERE DBO.TRIM(ZON) <> 'LIM'
    AND DBO.TRIM(CODSEG) IN ('0','00','1','01','2','02','3','03','4','04','5','05','6','06','7','07')

/*-----------------------------------------------------------------*/


UPDATE A
SET A.MODARM = 'X'
FROM ICOBRE A JOIN MODARM B ON A.CMDF = B.MDF
WHERE DBO.TRIM(A.ZON) <> 'LIM'
    AND DBO.TRIM(A.TI_LIQN) IN ('15','24')

/*-----------------------------------------------------------------*/


UPDATE A
SET A.INSMDF = 'X'
FROM ICOBRE A JOIN MDF_INSOURCING2015 B ON A.CMDF = B.MDF
WHERE DBO.TRIM(A.ZON) <> 'LIM'
    AND DBO.TRIM(A.TI_LIQN) IN ('31','32','33','34')

/*-----------------------------------------------------------------*/

UPDATE A
SET A.MICROZONAS = B.MICROZONAS, A.MZ2 = B.MZ4
FROM ICOBRE A JOIN MZ_COBRE_201502 B ON A.CMDF = B.MDF


-- *************************************************************************************************
-------------------CALC_INF_STB.SQL------------------------------------------------------------


-- ELIMINAR LOS REGISTROS CON LOS CAMPOS DE CODSEG Y AREA QUE TENGAN LAS SIGUIENTES VARIABLES
DELETE FROM ICOBRE WHERE CODSEG IN ('0','00','1','2','3','4','5','6','7') AND DBO.TRIM(AREA) = 'L'

/*-----------------------------------------------------------------*/
--CREACION DE LOS INDICES CMDF, TI_LIQN Y CO_UNICO
/*
CREATE INDEX CMDF
ON ICOBRE (CMDF);

CREATE INDEX TI_LIQN
ON ICOBRE (TI_LIQN);

CREATE INDEX CO_UNICO
ON ICOBRE (CO_UNICO);
*/
/*-----------------------------------------------------------------*/


UPDATE A
SET A.CLASIF = B.CLASIF_NUEVA
FROM ICOBRE A JOIN CODLIQ_ADSL_2017  B ON A.TI_LIQN= B.COD_LIQ
WHERE A.TI_LIQN IS NOT NULL
    AND DBO.TRIM(A.NEGOCIO)='STB'

/*-----------------------------------------------------------------*/

-- UNION DE LOS CAMPOS DEFINIDOS DE LA TABLA ICOBRE CON LOS DE RUTEMPP

UPDATE A
SET A.MODRUTAS = 'X'
FROM ICOBRE A JOIN RUTEMPP B ON A.CMDF = B.MDF
WHERE DBO.TRIM(ZON) <> 'LIM'
    AND DBO.TRIM(CODSEG) IN ('0','00','1','01','2','02','3','03','4','04','5','05','6','06','7','07')

/*-----------------------------------------------------------------*/

--UNION DE LOS CAMPOS DEFINIDOS DE LA TABLA ICOBRE CON LOS DE MODARM

UPDATE A
SET A.MODARM = 'X'
FROM ICOBRE A JOIN MODARM B ON A.CMDF = B.MDF
WHERE DBO.TRIM(A.ZON) <> 'LIM'
    AND DBO.TRIM(A.TI_LIQN) IN ('15','24')

/*-----------------------------------------------------------------*/

--UNION DE LOS CAMPOS DEFINIDOS DE LA TABLA ICOBRE CON LOS DE MDF_INSOURCING

UPDATE A
SET A.INSMDF = 'X'
FROM ICOBRE A JOIN MDF_INSOURCING2015 B ON A.CMDF = B.MDF
WHERE DBO.TRIM(A.ZON) <> 'LIM'
    AND DBO.TRIM(A.TI_LIQN) IN ('31','32','33','34')

/*-----------------------------------------------------------------*/

--UNION DE LOS CAMPOS DEFINIDOS DE LA TABLA ICOBRE CON LOS DE MZ_COBRE

UPDATE A
SET A.MICROZONAS = B.MICROZONAS, A.MZ2 = B.MZ4
FROM ICOBRE A JOIN MZ_COBRE_201502 B ON A.CMDF = B.MDF


-- *************************************************************************************************
-------------------CALC_REIT_ADSL.SQL------------------------------------------------------------


-- ELIMINAR LOS REGISTROS CON LOS CAMPOS DE CODSEG Y AREA QUE TENGAN LAS SIGUIENTES VARIABLES
DELETE FROM RCOBRE WHERE CODSEG IN ('0','00','1','2','3','4','5','6','7') AND AREA = 'L'


--AGREGAR COLUMNAS A LA TABLA RCOBRE
/*
ALTER TABLE RCOBRE ADD grp_tipo NVARCHAR(250)
ALTER TABLE RCOBRE ADD clasif1 NVARCHAR(250)
ALTER TABLE RCOBRE ADD clasif2 NVARCHAR(250)
ALTER TABLE RCOBRE ADD modrutas NVARCHAR(250)
ALTER TABLE RCOBRE ADD modarm NVARCHAR(250)
ALTER TABLE RCOBRE ADD insmdf NVARCHAR(250)
ALTER TABLE RCOBRE ADD deleqp NVARCHAR(250)
ALTER TABLE RCOBRE ADD result NVARCHAR(250)
ALTER TABLE RCOBRE ADD microzonas NVARCHAR(250)
ALTER TABLE RCOBRE ADD MZ2 NVARCHAR(250)
*/

/*-----------------------------------------------------------------*/
--CREACION DE LOS INDICES CO_MDF, RE_TI_LIQN Y CODAVERIA
/*
CREATE INDEX CO_MDF
ON RCOBRE (CO_MDF);

CREATE INDEX TI_LIQN
ON RCOBRE (TI_LIQN);

CREATE INDEX RE_TI_LIQN
ON RCOBRE (RE_TI_LIQN);

CREATE INDEX CODAVERIA
ON RCOBRE (CODAVERIA);
*/
/*-----------------------------------------------------------------*/

--UNION DE LOS CAMPOS DEFINIDOS DE LA TABLA RCOBRE CON LOS DE CODLIQ_ADSL_2017

UPDATE A
SET A.CLASIF1 = B.CLASIF_NUEVA
FROM RCOBRE A JOIN CODLIQ_ADSL_2017 B ON A.TI_LIQN= B.COD_LIQ
WHERE A.TI_LIQN IS NOT NULL

/*-----------------------------------------------------------------*/

--UNION DE LOS CAMPOS DEFINIDOS DE LA TABLA RCOBRE CON LOS DE CODLIQ_ADSL_2017

UPDATE A
SET A.CLASIF2 = B.CLASIF_NUEVA
FROM RCOBRE A JOIN CODLIQ_ADSL_2017 B ON A.RE_TI_LIQN= B.COD_LIQ
WHERE A.RE_TI_LIQN IS NOT NULL
/*-----------------------------------------------------------------*/

--REEMPLAZAR EL CAMPO MODRUTAS POR X DE LA TABLA RCOBRE CON LAS CONDICIONES REQUERIDAS

UPDATE A
SET A.MODRUTAS = 'X'
FROM RCOBRE A JOIN RUTEMPP B ON A.CO_MDF = B.MDF
WHERE DBO.TRIM(A.ZON) <> 'LIM'
    AND DBO.TRIM(A.CODSEG) IN ('0','00','1','01','2','02','3','03','4','04','5','05','6','06','7','07')

/*-----------------------------------------------------------------*/
--REEMPLAZAR EL CAMPO MODARM POR X y Y DE LA TABLA RCOBRE CON LAS CONDICIONES REQUERIDAS

UPDATE A
SET A.MODARM = 'X'
FROM RCOBRE A JOIN MODARM B ON A.CO_MDF = B.MDF
WHERE DBO.TRIM(A.ZON) <> 'LIM'
    AND DBO.TRIM(A.TI_LIQN) IN ('15','24')

UPDATE A
SET A.MODARM = 'Y'
FROM RCOBRE A JOIN MODARM B ON A.CO_MDF = B.MDF
WHERE DBO.TRIM(A.ZON) <> 'LIM'
    AND DBO.TRIM(A.RE_TI_LIQN) IN ('15','24')

/*-----------------------------------------------------------------*/

--REEMPLAZAR EL CAMPO INSMDF POR X y Y DE LA TABLA RCOBRE CON LAS CONDICIONES REQUERIDAS

UPDATE A
SET A.INSMDF = 'X'
FROM RCOBRE A JOIN MDF_INSOURCING2015 B ON A.CO_MDF = B.MDF
WHERE DBO.TRIM(A.ZON) <> 'LIM'
    AND DBO.TRIM(A.TI_LIQN) IN ('31','32','33','34')

UPDATE A
SET A.INSMDF = 'Y'
FROM RCOBRE A JOIN MDF_INSOURCING2015 B ON A.CO_MDF = B.MDF
WHERE DBO.TRIM(A.ZON) <> 'LIM'
    AND DBO.TRIM(A.RE_TI_LIQN) IN ('31','32','33','34')

/*-----------------------------------------------------------------*/

--ACTUALIZAR EL CAMPO RESULT CON EL VALOR DE 1 DE LA TABLA RECOBRE CON LAS CONDICIONES REQUERIDAS

UPDATE RCOBRE
SET RESULT = '1'
WHERE DBO.TRIM(CLASIF1) = 'EFECTIVA' AND DBO.TRIM(CLASIF2) IN ('EFECTIVA','INEFECTIVA') AND DBO.TRIM(NEGOCIO) = 'ADSL'
/*-----------------------------------------------------------------*/

--UNION DE LOS CAMPOS DEFINIDOS DE LA TABLA RCOBRE CON LOS DE MZ_COBRE

UPDATE A
SET A.MZ2 = B.MZ4
FROM RCOBRE A JOIN MZ_COBRE_201502 B ON A.CO_MDF = B.MDF

/*-----------------------------------------------------------------*/

-- *************************************************************************************************
-------------------CALC_REIT_STB.SQL------------------------------------------------------------


-- ELIMINAR LOS REGISTROS CON LOS CAMPOS DE CODSEG Y AREA QUE TENGAN LAS SIGUIENTES VARIABLES
DELETE FROM RCOBRE WHERE CODSEG IN ('0','00','1','2','3','4','5','6','7') AND AREA = 'L'

/*-----------------------------------------------------------------*/

--CREACION DE LOS INDICES CO_MDF, RE_TI_LIQN Y CODAVERIA
/*
CREATE INDEX CO_MDF
ON RCOBRE (CO_MDF);

CREATE INDEX TI_LIQN
ON RCOBRE (TI_LIQN);

CREATE INDEX RE_TI_LIQN
ON RCOBRE (RE_TI_LIQN);

CREATE INDEX CODAVERIA
ON RCOBRE (CODAVERIA);
*/
/*-----------------------------------------------------------------*/

--UNION DE LOS CAMPOS DEFINIDOS DE LA TABLA RCOBRE CON LOS DE CODLIQ_STB_2017

UPDATE A
SET A.CLASIF1 = B.CLASIF
FROM RCOBRE A JOIN CODLIQ_STB_2017 B ON A.TI_LIQN= B.COD_LIQ
WHERE A.TI_LIQN IS NOT NULL

/*-----------------------------------------------------------------*/

--UNION DE LOS CAMPOS DEFINIDOS DE LA TABLA RCOBRE CON LOS DE CODLIQ_STB_2017

UPDATE A
SET A.CLASIF2 = B.CLASIF
FROM RCOBRE A JOIN CODLIQ_STB_2017 B ON A.RE_TI_LIQN= B.COD_LIQ
WHERE A.RE_TI_LIQN IS NOT NULL

/*-----------------------------------------------------------------*/

--REEMPLAZAR EL CAMPO MODRUTAS POR X DE LA TABLA RCOBRE CON LAS CONDICIONES REQUERIDAS

UPDATE A
SET A.MODRUTAS = 'X'
FROM RCOBRE A JOIN RUTEMPP B ON A.CO_MDF = B.MDF
WHERE DBO.TRIM(A.ZON) <> 'LIM'
    AND DBO.TRIM(A.CODSEG) IN ('0','00','1','01','2','02','3','03','4','04','5','05','6','06','7','07')

/*-----------------------------------------------------------------*/

--REEMPLAZAR EL CAMPO MODARM POR X y Y DE LA TABLA RCOBRE CON LAS CONDICIONES REQUERIDAS

UPDATE A
SET A.MODARM = 'X'
FROM RCOBRE A JOIN MODARM B ON A.CO_MDF = B.MDF
WHERE DBO.TRIM(A.ZON) <> 'LIM'
    AND DBO.TRIM(A.TI_LIQN) IN ('15','24')

UPDATE A
SET A.MODARM = 'Y'
FROM RCOBRE A JOIN MODARM B ON A.CO_MDF = B.MDF
WHERE DBO.TRIM(A.ZON) <> 'LIM'
    AND DBO.TRIM(A.RE_TI_LIQN) IN ('15','24')

/*-----------------------------------------------------------------*/

--REEMPLAZAR EL CAMPO INSMDF POR X y Y DE LA TABLA RCOBRE CON LAS CONDICIONES REQUERIDAS

UPDATE A
SET A.INSMDF = 'X'
FROM RCOBRE A JOIN MDF_INSOURCING2015 B ON A.CO_MDF = B.MDF
WHERE DBO.TRIM(A.ZON) <> 'LIM'
    AND DBO.TRIM(A.TI_LIQN) IN ('31','32','33','34')

UPDATE A
SET A.INSMDF = 'Y'
FROM RCOBRE A JOIN MDF_INSOURCING2015 B ON A.CO_MDF = B.MDF
WHERE DBO.TRIM(A.ZON) <> 'LIM'
    AND DBO.TRIM(A.RE_TI_LIQN) IN ('31','32','33','34')

/*-----------------------------------------------------------------*/

--ACTUALIZAR EL CAMPO RESULT CON EL VALOR DE 1 DE LA TABLA RECOBRE CON LAS CONDICIONES REQUERIDAS

UPDATE RCOBRE
SET RESULT = '1'
WHERE DBO.TRIM(CLASIF1) = 'EFECTIVA' AND DBO.TRIM(CLASIF2) IN ('EFECTIVA','INEFECTIVA') AND DBO.TRIM(NEGOCIO) = 'STB'

/*-----------------------------------------------------------------*/

--UNION DE LOS CAMPOS DEFINIDOS DE LA TABLA RCOBRE CON LOS DE MZ_COBRE

UPDATE A
SET A.MZ2 = B.MZ4
FROM RCOBRE A JOIN MZ_COBRE_201502 B ON A.CO_MDF = B.MDF


/*-----------------------------------------------------------------*/

-- CORRIENDO EL PROCEDURE SMA_ADSL_STB_PROCEDURE
EXEC SMA_ADSL_STB_PROCEDURE @MES = 7, @ANIO = 2019


-- DROP TABLE ADSL_FINAL
SELECT * INTO ADSL_FINAL FROM (SELECT * FROM SMA_ADSL A WHERE DBO.TRIM(ESTALIQ) IN ('ZEI','STAR','RTNC','PEX','PAGE','VOIP') AND MODRUT=0
AND MODARM=0 AND INSMDF=0 AND TELEFONO='EFECTIVA' AND MM_LIQ = 7 AND AA_LIQ = 2019
) A

GO

-- NO DEVUELVE FILAS
-- DROP TABLE STB_FINAL
SELECT * INTO STB_FINAL FROM (SELECT * FROM SMA_STB A
WHERE MODRUTAS=0 AND INS_MDF=0 AND MODARM=0 AND DBO.TRIM(CLASIF)='EFECTIVA' AND SUBSTRING(COD_UNICO,1,2)<>'RU') A

GO

--SELECCIONAR CAMPOS ESPECIFICOS DE LA TABLA ICOBRE
-- CREACION DE LA TABLA INF_STB
-- DROP TABLE INF_STB
SELECT * INTO INF_STB FROM ICOBRE WHERE DBO.TRIM(NEGOCIO) = 'STB' AND CLASIF = 'EFECTIVA' AND MONTH(FEJEPEX) = '7' AND FE_LIQU-FEJEPEX >= 0 AND FE_LIQU-FEJEPEX <= 30 AND
MODRUTAS IS NULL AND MODARM IS NULL AND INSMDF IS NULL

SELECT EECC FROM INF_STB
GO

-- CREACION DE LA TABLA REIT_ADSL
-- DROP TABLE REIT_ADSL
SELECT * INTO REIT_ADSL FROM RCOBRE WHERE DBO.TRIM(NEGOCIO) = 'ADSL' AND MONTH(FE_LIQU) = '7' AND DBO.TRIM(RESULT) = '1' AND RE_FE_REPO-FE_LIQU >= 0
AND RE_FE_REPO-FE_LIQU <= 30 AND MODRUTAS IS NULL AND MODARM IS NULL AND INSMDF IS NULL
AND AREALIQ IN ('ZEI','STAR','RTNC','PEX','VOIP','PAGE') AND RE_AREALIQ IN ('ZEI','STAR','RTNC','PEX','VOIP','PAGE')

GO

-- CREACION DE LA TABLA REIT_STB
-- DROP TABLE REIT_STB
SELECT * INTO REIT_STB FROM RCOBRE WHERE DBO.TRIM(NEGOCIO) = 'STB' AND MONTH(FE_LIQU) = '07' AND DBO.TRIM(RESULT) = '1'
AND RE_FE_REPO-FE_LIQU >= 0 AND RE_FE_REPO-FE_LIQU <= 30 AND MODRUTAS IS NULL AND MODARM IS NULL AND INSMDF IS NULL

GO

-- CREACION DE LA TABLA INF_ADSL
-- DROP TABLE INF_ADSL
SELECT * INTO INF_ADSL FROM ICOBRE WHERE DBO.TRIM(NEGOCIO) = 'ADSL' AND CLASIF = 'EFECTIVA' AND MONTH(FEJEPEX) = '7' AND FE_LIQU-FEJEPEX >= 0
 AND FE_LIQU-FEJEPEX <= 30 AND MODRUTAS IS NULL AND MODARM IS NULL AND INSMDF IS NULL

GO

DROP TABLE INF_STB
DROP TABLE REIT_ADSL
DROP TABLE REIT_STB
DROP TABLE INF_ADSL
