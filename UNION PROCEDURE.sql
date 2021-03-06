USE PV_STC_COMISIONES
-------------------SMA_ADSL_2019.SQL-----------------
/*
 DROP PROCEDURE SMA_ADSL_STB_PROCEDURE
 DROP TABLE SMA_ADSL
 DROP TABLE SMA_STB
 DROP TABLE INF_ADSL
 DROP TABLE REIT_ADSL
 DROP TABLE REIT_STB
 DROP TABLE ADSL_FINAL
 DROP TABLE STB_FINAL
 DROP TABLE INF_STB
 DROP TABLE STB_FINAL
 DROP TABLE ADSL_FINAL
 DROP TABLE RCOBRE_ADSL
 DROP TABLE RCOBRE_STB
 */
SELECT * INTO SMA_ADSL FROM ADSL;
ALTER TABLE SMA_ADSL ADD CSEG VARCHAR(250);
ALTER TABLE SMA_ADSL ADD TELEFONO NVARCHAR(255);
ALTER TABLE SMA_ADSL ADD MODRUT INT;
ALTER TABLE SMA_ADSL ADD INSMDF INT;
ALTER TABLE SMA_ADSL ADD MODARM INT;

SELECT * INTO SMA_STB FROM STB;
ALTER TABLE SMA_STB ADD CSEG VARCHAR(255)
ALTER TABLE SMA_STB ADD MODRUTAS INT
ALTER TABLE SMA_STB ADD INS_MDF INT
ALTER TABLE SMA_STB ADD CLASIF NVARCHAR(255)
ALTER TABLE SMA_STB ALTER COLUMN TI_LIQN NVARCHAR(255)
ALTER TABLE SMA_STB ADD MODARM INT

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

ALTER TABLE RCOBRE_ADSL ADD grp_tipo NVARCHAR(250)
ALTER TABLE RCOBRE_ADSL ADD clasif1 NVARCHAR(250)
ALTER TABLE RCOBRE_ADSL ADD clasif2 NVARCHAR(250)
ALTER TABLE RCOBRE_ADSL ADD modrutas NVARCHAR(250)
ALTER TABLE RCOBRE_ADSL ADD modarm NVARCHAR(250)
ALTER TABLE RCOBRE_ADSL ADD insmdf NVARCHAR(250)
ALTER TABLE RCOBRE_ADSL ADD deleqp NVARCHAR(250)
ALTER TABLE RCOBRE_ADSL ADD result NVARCHAR(250)
ALTER TABLE RCOBRE_ADSL ADD microzonas NVARCHAR(250)
ALTER TABLE RCOBRE_ADSL ADD MZ2 NVARCHAR(250)

ALTER TABLE RCOBRE_STB ADD grp_tipo NVARCHAR(250)
ALTER TABLE RCOBRE_STB ADD clasif1 NVARCHAR(250)
ALTER TABLE RCOBRE_STB ADD clasif2 NVARCHAR(250)
ALTER TABLE RCOBRE_STB ADD modrutas NVARCHAR(250)
ALTER TABLE RCOBRE_STB ADD modarm NVARCHAR(250)
ALTER TABLE RCOBRE_STB ADD insmdf NVARCHAR(250)
ALTER TABLE RCOBRE_STB ADD deleqp NVARCHAR(250)
ALTER TABLE RCOBRE_STB ADD result NVARCHAR(250)
ALTER TABLE RCOBRE_STB ADD microzonas NVARCHAR(250)
ALTER TABLE RCOBRE_STB ADD MZ2 NVARCHAR(250)

CREATE PROCEDURE SMA_ADSL_STB_PROCEDURE @MES FLOAT, @ANIO FLOAT
AS

--*********************************************************************************************
-------------------SMA_ADSL_2019.PRG------------------------------------------------------------

UPDATE SMA_ADSL
SET MODRUT = 0
WHERE MODRUT IS NULL;

UPDATE SMA_ADSL
SET CSEG = 'E'
WHERE CODSEG IN ('00','01','02','03','04','05','06','07')
AND MM_LIQ = @MES AND AA_LIQ = @ANIO;

UPDATE SMA_ADSL
SET MODRUT = 1
WHERE DBO.TRIM(ZON)='LIM' AND MM_LIQ = @MES AND CSEG = 'E'

UPDATE SMA_ADSL
SET TELEFONO = 0
WHERE TELEFONO IS NULL;

UPDATE A
SET A.TELEFONO = B.CLASIF
FROM SMA_ADSL A JOIN CODLIQ_ADSL_2017 B ON A.CODLIQ = B.COD_LIQ
WHERE A.MM_LIQ = @MES AND  A.AA_LIQ = @ANIO;

UPDATE A
SET A.MODRUT = 1
FROM SMA_ADSL A JOIN RUTEMPP B ON A.MDF = B.MDF
WHERE LEN(DBO.TRIM(A.MDF)) = 4
	AND (A.CSEG) = 'E'
	AND A.MM_LIQ = @MES
	AND A.AA_LIQ = @ANIO;

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

UPDATE A
SET INSMDF = 1
FROM SMA_ADSL A JOIN MDF_INSOURCING2015 B ON A.MDF = B.MDF
WHERE DBO.TRIM(A.CODLIQ) IN ('31','32','33','34')
	AND B.SWITCH = 1
	AND A.MM_LIQ = @MES;
	--AND A.AA_LIQ = @ANIO;

UPDATE SMA_ADSL
SET MODARM = 0
WHERE MODARM IS NULL;

UPDATE A
SET MODARM = 1
FROM SMA_ADSL A JOIN MODARM B ON (A.MDF = B.MDF)
WHERE DBO.TRIM(A.CODLIQ) IN ('15','24')
	AND A.MM_LIQ = @MES
	AND A.AA_LIQ = @ANIO;

--*********************************************************************************************
-------------------SMA_STB_2019.PRG------------------------------------------------------------


-- FILTROS Y MAS FILTROS
UPDATE SMA_STB
SET CSEG = 'E'
WHERE CODSEG IN ('00','01','02','03','04','05','06','07','0','1','2','3','4','5','6','7')
AND MM_LIQ = @MES
AND AA_LIQ = @ANIO;

UPDATE SMA_STB
SET MODRUTAS = 0
WHERE MODRUTAS IS NULL;

UPDATE SMA_STB
SET MODRUTAS = 1
WHERE DBO.TRIM(ZONAL) = 'LIMA' AND CSEG = 'E' AND MM_LIQ = @MES;
--AND AA_LIQ = @ANIO;

UPDATE A
SET A.MODRUTAS = 1
FROM SMA_STB A JOIN RUTEMPP B ON A.MDF = B.MDF
WHERE LEN(DBO.TRIM(A.MDF)) = 4
	AND CSEG = 'E'
	AND A.MM_LIQ = @MES
	AND A.AA_LIQ = @ANIO;

UPDATE SMA_STB
SET INS_MDF = 0
WHERE INS_MDF IS NULL

UPDATE A
SET INS_MDF = 1
FROM SMA_STB A JOIN MDF_INSOURCING2015 B ON A.MDF = B.MDF
WHERE DBO.TRIM(TI_LIQN) IN ('31','32','33','34')
      AND B.SWITCH = 1
      AND A.MM_LIQ = @MES
	  AND A.AA_LIQ = @ANIO;

UPDATE SMA_STB
SET CLASIF = 0
WHERE CLASIF IS NULL

UPDATE A
SET A.CLASIF = B.CLASIF
FROM SMA_STB A JOIN CODLIQ_STB_2017 B ON A.TI_LIQN = B.COD_LIQ
WHERE A.MM_LIQ = @MES
	  AND A.AA_LIQ = @ANIO;

UPDATE SMA_STB
SET MODARM = 0
WHERE MODARM IS NULL;

UPDATE A
SET MODARM = 1
FROM SMA_STB A JOIN MODARM B ON A.MDF = B.MDF
WHERE  DBO.TRIM(A.TI_LIQN) IN ('15', '24')
	  AND A.MM_LIQ = @MES
	  AND A.AA_LIQ = @ANIO;

--*********************************************************************************************
-------------------CALC_INF_ADSL_ACT.SQL-------------------------------------------------------

/*
-- ELIMINAR LOS REGISTROS CON LOS CAMPOS DE CODSEG Y AREA QUE TENGAN LAS SIGUIENTES VARIABLES
DELETE FROM ICOBRE WHERE CODSEG IN ('0','00','1','2','3','4','5','6','7') AND AREA = 'L'


--AGREGAR COLUMNAS A LA TABLA ICOBRE
/*
--ALTER TABLE ICOBRE ADD grp_tipo NVARCHAR(250)
--ALTER TABLE ICOBRE ADD clasif NVARCHAR(250)
--ALTER TABLE ICOBRE ADD modrutas NVARCHAR(250)
--ALTER TABLE ICOBRE ADD modarm NVARCHAR(250)
--ALTER TABLE ICOBRE ADD insmdf NVARCHAR(250)
--ALTER TABLE ICOBRE ADD deleqp NVARCHAR(250)
--ALTER TABLE ICOBRE ADD microzonas NVARCHAR(250)
--ALTER TABLE ICOBRE ADD MZ2 NVARCHAR(250)
*/

--REVISAR --> FROM ICOBRE A JOIN CODLIQ_ADSL_2017 B ON A.TI_LIQN = B.COD_LIQ
UPDATE A
SET A.CLASIF = B.CLASIF
FROM ICOBRE A JOIN CODLIQ_ADSL_2017 B ON A.TI_LIQN = B.COD_LIQ
WHERE A.TI_LIQN IS NOT NULL
	  AND DBO.TRIM(A.NEGOCIO) = 'ADSL'

UPDATE A
SET A.MODRUTAS = 'X'
FROM ICOBRE A JOIN RUTEMPP B ON A.CMDF = B.MDF
WHERE DBO.TRIM(ZON) <> 'LIM'
    AND DBO.TRIM(CODSEG) IN ('0','00','1','01','2','02','3','03','4','04','5','05','6','06','7','07')

UPDATE A
SET A.MODARM = 'X'
FROM ICOBRE A JOIN MODARM B ON A.CMDF = B.MDF
WHERE DBO.TRIM(A.ZON) = 'LIM'
    AND DBO.TRIM(A.TI_LIQN) IN ('15','24')

UPDATE A
SET A.INSMDF = 'X'
FROM ICOBRE A JOIN MDF_INSOURCING2015 B ON A.CMDF = B.MDF
WHERE DBO.TRIM(A.ZON) = 'LIM'
    AND DBO.TRIM(A.TI_LIQN) IN ('31','32','33','34')

UPDATE A
SET A.MICROZONAS = B.MICROZONAS, A.MZ2 = B.MZ4
FROM ICOBRE A JOIN MZ_COBRE_201502 B ON A.CMDF = B.MDF

-- ********************************************************************************************
-------------------CALC_INF_STB.SQL------------------------------------------------------------

-- ELIMINAR LOS REGISTROS CON LOS CAMPOS DE CODSEG Y AREA QUE TENGAN LAS SIGUIENTES VARIABLES
DELETE FROM ICOBRE WHERE CODSEG IN ('0','00','1','2','3','4','5','6','7') AND DBO.TRIM(AREA) = 'L'

UPDATE A
SET A.CLASIF = B.CLASIF
FROM ICOBRE A JOIN CODLIQ_ADSL_2017  B ON A.TI_LIQN= B.COD_LIQ
WHERE A.TI_LIQN IS NOT NULL
    AND DBO.TRIM(A.NEGOCIO)='STB'

UPDATE A
SET A.MODRUTAS = 'X'
FROM ICOBRE A JOIN RUTEMPP B ON A.CMDF = B.MDF
WHERE DBO.TRIM(ZON) <> 'LIM'
    AND DBO.TRIM(CODSEG) IN ('0','00','1','01','2','02','3','03','4','04','5','05','6','06','7','07')

UPDATE A
SET A.MODARM = 'X'
FROM ICOBRE A JOIN MODARM B ON A.CMDF = B.MDF
WHERE DBO.TRIM(A.ZON) = 'LIM'
    AND DBO.TRIM(A.TI_LIQN) IN ('15','24')

UPDATE A
SET A.INSMDF = 'X'
FROM ICOBRE A JOIN MDF_INSOURCING2015 B ON A.CMDF = B.MDF
WHERE DBO.TRIM(A.ZON) = 'LIM'
    AND DBO.TRIM(A.TI_LIQN) IN ('31','32','33','34')

UPDATE A
SET A.MICROZONAS = B.MICROZONAS, A.MZ2 = B.MZ4
FROM ICOBRE A JOIN MZ_COBRE_201502 B ON A.CMDF = B.MDF
*/

-- **********************************************************************************************
-------------------CALC_REIT_ADSL.PRG------------------------------------------------------------

DELETE FROM RCOBRE_ADSL WHERE CODSEG IN ('0','00','1','2','3','4','5','6','7','01','02','03','04','05','06','07') AND DBO.TRIM(AREA) = 'L'

UPDATE RCOBRE_ADSL
SET INSMDF = 0
WHERE INSMDF IS NULL

UPDATE RCOBRE_STB
SET INSMDF = 0
WHERE INSMDF IS NULL

UPDATE RCOBRE_ADSL
SET MODRUTAS = 0
WHERE MODRUTAS IS NULL

UPDATE RCOBRE_STB
SET MODRUTAS = 0
WHERE MODRUTAS IS NULL

UPDATE RCOBRE_ADSL
SET MODARM = 0
WHERE MODARM IS NULL

UPDATE RCOBRE_STB
SET MODARM = 0
WHERE MODARM IS NULL

UPDATE RCOBRE_ADSL
SET RESULT = '0'
WHERE RESULT IS NULL

UPDATE RCOBRE_STB
SET RESULT = '0'
WHERE RESULT IS NULL

UPDATE A
SET A.CLASIF1 = B.CLASIF
FROM RCOBRE_ADSL A JOIN CODLIQ_ADSL_2017 B ON A.TI_LIQN= B.COD_LIQ
WHERE A.TI_LIQN IS NOT NULL

UPDATE A
SET A.CLASIF2 = B.CLASIF
FROM RCOBRE_ADSL A JOIN CODLIQ_ADSL_2017 B ON A.RE_TI_LIQN= B.COD_LIQ
WHERE A.RE_TI_LIQN IS NOT NULL

UPDATE A
SET A.MODRUTAS = 'X'
FROM RCOBRE_ADSL A JOIN RUTEMPP B ON A.CO_MDF = B.MDF
WHERE DBO.TRIM(A.ZON) <> 'LIM'
    AND DBO.TRIM(A.CODSEG) IN ('0','00','1','01','2','02','3','03','4','04','5','05','6','06','7','07')

UPDATE A
SET A.MODARM = 'X'
FROM RCOBRE_ADSL A JOIN MODARM B ON A.CO_MDF = B.MDF
WHERE DBO.TRIM(A.ZON) = 'LIM'
    AND DBO.TRIM(A.TI_LIQN) IN ('15','24')

UPDATE A
SET A.MODARM = 'Y'
FROM RCOBRE_ADSL A JOIN MODARM B ON A.CO_MDF = B.MDF
WHERE DBO.TRIM(A.ZON) = 'LIM'
    AND DBO.TRIM(A.RE_TI_LIQN) IN ('15','24')

UPDATE A
SET A.INSMDF = 'X'
FROM RCOBRE_ADSL A JOIN MDF_INSOURCING2015 B ON A.CO_MDF = B.MDF
WHERE DBO.TRIM(A.ZON) = 'LIM'
    AND DBO.TRIM(A.TI_LIQN) IN ('31','32','33','34')

UPDATE A
SET A.INSMDF = 'Y'
FROM RCOBRE_ADSL A JOIN MDF_INSOURCING2015 B ON A.CO_MDF = B.MDF
WHERE DBO.TRIM(A.ZON) = 'LIM'
    AND DBO.TRIM(A.RE_TI_LIQN) IN ('31','32','33','34')

UPDATE RCOBRE_ADSL
SET RESULT = '1'
WHERE DBO.TRIM(CLASIF1) = 'EFECTIVA' AND DBO.TRIM(CLASIF2) IN ('EFECTIVA','INEFECTIVA') AND DBO.TRIM(NEGOCIO) = 'ADSL'

UPDATE A
SET A.MZ2 = B.MZ4
FROM RCOBRE_ADSL A JOIN MZ_COBRE_201502 B ON A.CO_MDF = B.MDF

-- *********************************************************************************************
-------------------CALC_REIT_STB.SQL------------------------------------------------------------
DELETE FROM RCOBRE_STB WHERE CODSEG IN ('0','00','1','2','3','4','5','6','7','01','02','03','04','05','06','07') AND DBO.TRIM(AREA) = 'L'

UPDATE A
SET A.CLASIF1 = B.CLASIF
FROM RCOBRE_STB A JOIN CODLIQ_STB_2017 B ON A.TI_LIQN= B.COD_LIQ
WHERE A.TI_LIQN IS NOT NULL

UPDATE A
SET A.CLASIF2 = B.CLASIF
FROM RCOBRE_STB A JOIN CODLIQ_STB_2017 B ON A.RE_TI_LIQN= B.COD_LIQ
WHERE A.RE_TI_LIQN IS NOT NULL

UPDATE A
SET A.MODRUTAS = 'X'
FROM RCOBRE_STB A JOIN RUTEMPP B ON A.CO_MDF = B.MDF
WHERE DBO.TRIM(A.ZON) <> 'LIM'
    AND DBO.TRIM(A.CODSEG) IN ('0','00','1','01','2','02','3','03','4','04','5','05','6','06','7','07')

UPDATE A
SET A.MODARM = 'X'
FROM RCOBRE_STB A JOIN MODARM B ON A.CO_MDF = B.MDF
WHERE DBO.TRIM(A.ZON) = 'LIM'
    AND DBO.TRIM(A.TI_LIQN) IN ('15','24')

UPDATE A
SET A.MODARM = 'Y'
FROM RCOBRE_STB A JOIN MODARM B ON A.CO_MDF = B.MDF
WHERE DBO.TRIM(A.ZON) = 'LIM'
    AND DBO.TRIM(A.RE_TI_LIQN) IN ('15','24')

UPDATE A
SET A.INSMDF = 'X'
FROM RCOBRE_STB A JOIN MDF_INSOURCING2015 B ON A.CO_MDF = B.MDF
WHERE DBO.TRIM(A.ZON) = 'LIM'
    AND DBO.TRIM(A.TI_LIQN) IN ('31','32','33','34')

UPDATE A
SET A.INSMDF = 'Y'
FROM RCOBRE_STB A JOIN MDF_INSOURCING2015 B ON A.CO_MDF = B.MDF
WHERE DBO.TRIM(A.ZON) = 'LIM'
    AND DBO.TRIM(A.RE_TI_LIQN) IN ('31','32','33','34')

UPDATE RCOBRE_STB
SET RESULT = '1'
WHERE DBO.TRIM(CLASIF1) = 'EFECTIVA' AND DBO.TRIM(CLASIF2) IN ('EFECTIVA','INEFECTIVA') AND DBO.TRIM(NEGOCIO) = 'STB'

UPDATE A
SET A.MZ2 = B.MZ4
FROM RCOBRE_STB A JOIN MZ_COBRE_201502 B ON A.CO_MDF = B.MDF

--**********************************************
-- CORRIENDO EL PROCEDURE SMA_ADSL_STB_PROCEDURE
EXEC SMA_ADSL_STB_PROCEDURE @MES = 9, @ANIO = 2019


-- CREANDO LA TABLA ADSL_FINAL
SELECT * INTO ADSL_FINAL FROM (SELECT * FROM SMA_ADSL A WHERE DBO.TRIM(ESTALIQ) IN ('ZEI','STAR','RTNC','PEX','PAGE','VOIP') AND MODRUT=0
AND MODARM=0 AND INSMDF=0 AND TELEFONO='EFECTIVA' AND MM_LIQ = 9 AND AA_LIQ = 2019
) A

GO

-- CREANDO LA TABLA STB_FINAL
SELECT * INTO STB_FINAL FROM (SELECT * FROM SMA_STB A
WHERE MODRUTAS=0 AND INS_MDF=0 AND MODARM=0 AND DBO.TRIM(CLASIF)='EFECTIVA' AND SUBSTRING(COD_UNICO,1,2)<>'RU') A

GO

--CREANDO LA TABLA INF_STB
/*
SELECT * INTO INF_STB FROM ICOBRE WHERE DBO.TRIM(NEGOCIO) = 'STB' AND CLASIF = 'EFECTIVA' AND MONTH(FEJEPEX) = 7 AND FE_LIREIT_ADSLQU-FEJEPEX >= 0 AND FE_LIQU-FEJEPEX <= 30 AND
MODRUTAS IS NULL AND MODARM IS NULL AND INSMDF IS NULL
*/
GO

-- CREANDO LA TABLA REIT_ADSL
SELECT * INTO REIT_ADSL FROM RCOBRE_ADSL WHERE DBO.TRIM(NEGOCIO) = 'ADSL' AND MONTH(FE_LIQU) = '9' AND DBO.TRIM(RESULT) = '1' AND DATEDIFF(DAY, FE_LIQU,  RE_FE_REPO) >= 0
AND DATEDIFF(DAY, FE_LIQU,  RE_FE_REPO) <= 30 AND MODRUTAS = '0' AND MODARM = '0' AND INSMDF = '0'
AND AREALIQ IN ('ZEI','STAR','RTNC','PEX','VOIP','PAGE') AND RE_AREALIQ IN ('ZEI','STAR','RTNC','PEX','VOIP','PAGE')

GO

-- CREANDO LA TABLA REIT_STB
SELECT * INTO REIT_STB FROM RCOBRE_STB WHERE DBO.TRIM(NEGOCIO) = 'STB' AND MONTH(FE_LIQU) = '09' AND DBO.TRIM(RESULT) = '1'
AND DATEDIFF(DAY, FE_LIQU, RE_FE_REPO) >= 0  AND DATEDIFF(DAY, FE_LIQU, RE_FE_REPO) <= 30 AND MODRUTAS = '0' AND MODARM = '0' AND INSMDF = '0'

GO

-- CREANDO LA TABLA INF_ADSL
/*
SELECT * INTO INF_ADSL FROM ICOBRE WHERE DBO.TRIM(NEGOCIO) = 'ADSL' AND CLASIF = 'EFECTIVA' AND MONTH(FEJEPEX) = '9' AND FE_LIQU-FEJEPEX >= 0
 AND FE_LIQU-FEJEPEX <= 30 AND MODRUTAS IS NULL AND MODARM IS NULL AND INSMDF IS NULL
*/


SELECT COUNT(*) FILAS_ADSL_FINAL FROM ADSL_FINAL;
SELECT COUNT(*) FILAS_STB_FINAL FROM STB_FINAL;
SELECT COUNT(*) FILAS_REIT_ADSL FROM REIT_ADSL;
SELECT COUNT(*) FILAS_REIT_STB FROM REIT_STB;
