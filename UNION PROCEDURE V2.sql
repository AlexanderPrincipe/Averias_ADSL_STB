


--*******************************************************************
	-- CARGA_AVERIAS_DUO_A_DATA

ALTER TABLE ADSL_FINAL ADD CONTRATA NVARCHAR(255)

GO

UPDATE ADSL_FINAL
SET CONTRATA = 'COBRA'
WHERE SUBSTRING(CTECNICO,1,2) = 'AB'

GO

UPDATE ADSL_FINAL
SET CONTRATA = 'LARI'
WHERE SUBSTRING(CTECNICO,1,2) = 'LA'

GO

UPDATE ADSL_FINAL
SET CONTRATA = 'DOMINION'
WHERE SUBSTRING(CTECNICO,1,2) = 'DO'

GO

UPDATE ADSL_FINAL
SET CONTRATA = 'CALATEL'
WHERE SUBSTRING(CTECNICO,1,2) = 'CA'

GO

UPDATE ADSL_FINAL
SET A = 'P'
WHERE MDF IN ('HUAL', 'CHAN')

GO

UPDATE ADSL_FINAL
SET ZON = 'CHB'
WHERE MDF IN ('HUAL', 'CHAN')

GO

--------------------------------------------------------
/*
SELECT CECO FROM CUENTA WHERE NEGOCIO = 'SPEEDY' AND MOV = 'AVERIAS' --WCECO
SELECT COD_CUENTA FROM CUENTA WHERE NEGOCIO = 'SPEEDY' AND MOV = 'AVERIAS' --COD_CUENTA
SELECT AF FROM CUENTA WHERE NEGOCIO = 'SPEEDY' AND MOV = 'AVERIAS' --WAF
SELECT DESCTA FROM CUENTA WHERE NEGOCIO = 'SPEEDY' AND MOV = 'AVERIAS' --DESCTA¨
*/

UPDATE ADSL_FINAL
SET ZON = 'PRO'
WHERE A = 'P'

GO

UPDATE ADSL_FINAL
SET ZON = 'LIM'
WHERE A = 'L'

GO

UPDATE A
SET A.DESC_UNI = B.DESC_UNI,
    A.BAR_UNI = B.BAR_UNI,
    A.BAR_TOT = B.BAR_UNI
FROM data1908 A JOIN UNIDADES B ON A.COD_UNI = B.COD_UNI
WHERE B.COD_UNI = '72310-0'

/*
SELECT COD_UNI FROM data1908
SELECT * FROM UNIDADES
SELECT * FROM ADSL_FINAL
*/

GO

-- CUANDO EN EL SEEK SEA UNA COLUMNA O MAS UTILIZAR UN UPDATE-JOIN SIN WHERE
UPDATE A
SET A.PRECIO = B.PRECIO,
A.MONTO = A.BAR_TOT*A.PRECIO,
A.OPEX = A.BAR_TOT*A.PRECIO
FROM data1908 A JOIN PRECIOS B ON A.CONTRA = B.CONTRA AND A.ZONAL = B.ZONAL

GO

-- REVISAR CAMPOS
UPDATE A
SET A.CZONAL = B.CZONAL,
	A.JEFATURA = B.JEF_CMR,
	A.ZONAL_BONO = B.ZONAL_BONO,
	A.JEFA_MAT = B.JEFA_MAT
FROM data1908 A JOIN JEFATURAS_REGIONES B ON A.CMDF_NODO = B.MDF

GO


INSERT INTO data1908 (CECO ,	COD_CUENTA ,	AF ,	DESCTA ,	TIPO ,	DEFINICION ,	SOCIEDAD ,	CCONTR ,	CONTRA ,	ORDEN_OT ,
RUTAC ,	CODREQ ,	CZONAL ,	CMDF_NODO ,	--MOV_MAT
INS_CODCLI ,	TIPREQ ,	CODMOTV ,	NROPLANO ,	FECEJE ,	DESCRIPT ,	MOV ,	PLAYA ,	N_NEGOCIO ,	NEG_NUE ,	ACT_MAT ,	MOV_MAT ,
ACTIVIDAD ,	TELEFONO ,	PREFIJO ,	CODSER ,	CODMOV ,	TSPEEDYACT ,	MODALACT ,	IND_PAQ ,	CANT)
SELECT  (SELECT CECO FROM CUENTA WHERE NEGOCIO = 'SPEEDY' AND MOV = 'AVERIAS')
,	 (SELECT COD_CUENTA FROM CUENTA WHERE NEGOCIO = 'SPEEDY' AND MOV = 'AVERIAS')
,	 (SELECT AF FROM CUENTA WHERE NEGOCIO = 'SPEEDY' AND MOV = 'AVERIAS')
,	 (SELECT DESCTA FROM CUENTA WHERE NEGOCIO = 'SPEEDY' AND MOV = 'AVERIAS'),	 'BUCLE',	 'OPEX',	 'TDP',	 CODEECC,
CONTRATA,	 SUBSTRING(AVERIA,4,7),	 0,	 0,	 ZON,	 MDF	-- 'AVERIAS'
, 0,	 ' ',	 ' ',	 ' ',   FECHA_LIQU,	 DBO.TRIM(codliq)+'-'+DBO.TRIM(coddetliq)+'-'+DBO.TRIM(ddescodliq),	 'AVERIAS',	 0,	 'SPEEDY',
'AVERIAS ADSL',	 'BA',	 'AVERIAS',	 'AVERIAS ADSL',	 0,	 ' ',	 ' ',	 ' ',	 ' ',	 DESMODA,	 AVERIA,	 1
FROM ADSL_FINAL

GO

ALTER TABLE STB_FINAL ADD CONTRATA NVARCHAR(255)
GO

UPDATE STB_FINAL
SET CONTRATA = 'COBRA'
WHERE DBO.TRIM(EECC) = 'AB'

GO

UPDATE STB_FINAL
SET CONTRATA = 'LARI'
WHERE DBO.TRIM(EECC) = 'LA'

GO

UPDATE STB_FINAL
SET CONTRATA = 'DOMINION'
WHERE DBO.TRIM(EECC) = 'DO'

GO

UPDATE STB_FINAL
SET CONTRATA = 'CALATEL'
WHERE DBO.TRIM(EECC) = 'CA'

GO

UPDATE STB_FINAL
SET ZONAL = 'LIM'
WHERE ZONAL = 'LIM'

GO

UPDATE STB_FINAL
SET ZONAL = 'PRO'
WHERE ZONAL <> 'LIM'

GO
----------------------------------------------------------------------------------------------
UPDATE A
SET A.DESC_UNI = B.DESC_UNI,
	A.COD_UNI = B.COD_UNI,
    A.BAR_UNI = B.BAR_UNI,
    A.BAR_TOT = B.BAR_UNI
FROM data1908 A JOIN UNIDADES B ON A.COD_UNI = B.COD_UNI
WHERE B.COD_UNI = '72300-2'

GO

-- CUANDO EN EL SEEK SEA UNA COLUMNA O MAS UTILIZAR UN UPDATE-JOIN SIN WHERE
UPDATE A
SET A.PRECIO = B.PRECIO,
	A.MONTO = A.BAR_TOT*A.PRECIO,
	A.OPEX = A.BAR_TOT*A.PRECIO
FROM data1908 A JOIN PRECIOS B ON A.CONTRA = B.CONTRA AND A.ZONAL = B.ZONAL

/*
UPDATE A
SET A.PRECIO = B.PRECIO,
	A.MONTO = A.BAR_TOT*A.PRECIO,
	A.OPEX = A.BAR_TOT*A.PRECIO
FROM STB_FINAL A JOIN PRECIOS B ON A.CONTRATA = B.CONTRA AND A.ZONAL = B.ZONAL

ALTER TABLE STB_FINAL ADD PRECIO FLOAT;
ALTER TABLE STB_FINAL ADD MONTO FLOAT;
ALTER TABLE STB_FINAL ADD OPEX FLOAT;

SELECT OPEX FROM data1908

SELECT * FROM STB_FINAL
SELECT * FROM PRECIOS
*/
------------------------------------------
GO

-- REVISAR LOS CAMPOS
UPDATE A
SET A.CZONAL = B.CZONAL,
	A.JEFATURA = B.JEF_CMR,
	A.ZONAL_BONO = B.ZONAL_BONO,
	A.JEFA_MAT = B.JEFA_MAT
FROM data1908 A JOIN JEFATURAS_REGIONES B ON A.CMDF_NODO = B.MDF

GO

ALTER TABLE STB_FINAL ALTER COLUMN TI_LIQN_DE NVARCHAR(255)

-- ERROR DATA TYPE VARCHAR TO FLOAT -- ******************************************************************
INSERT INTO data1908 (CECO ,	COD_CUENTA ,	AF ,	DESCTA ,
TIPO ,	DEFINICION ,	SOCIEDAD ,	CCONTR ,
CONTRA ,	ORDEN_OT ,	RUTAC ,	CODREQ ,	CZONAL ,	CMDF_NODO ,	INS_CODCLI ,
TIPREQ ,	CODMOTV ,	NROPLANO ,	FECEJE ,
DESCRIPT ,	MOV ,	PLAYA ,	N_NEGOCIO ,	NEG_NUE ,	ACT_MAT ,	MOV_MAT ,	ACTIVIDAD ,	TELEFONO
,	PREFIJO ,	CODSER ,	CODMOV ,	TSPEEDYACT ,	MODALACT ,	IND_PAQ ,	CANT ,	COD_ACT
)
SELECT  (SELECT CECO FROM CUENTA WHERE NEGOCIO = 'SPEEDY' AND MOV = 'AVERIAS'),	 (SELECT COD_CUENTA FROM CUENTA WHERE NEGOCIO = 'SPEEDY' AND MOV = 'AVERIAS'),	 (SELECT AF FROM CUENTA WHERE NEGOCIO = 'SPEEDY' AND MOV = 'AVERIAS'),	 (SELECT DESCTA FROM CUENTA WHERE NEGOCIO = 'SPEEDY' AND MOV = 'AVERIAS'),
'BUCLE',	 'OPEX',	 'TDP',	 EECC,
CONTRATA,	 SUBSTRING(COD_UNICO,4,7),	 0,	 0,	 ZONAL,	 MDF,	 'AVERIAS',
	 ' ',	 ' ',	 ' ',	 FECHA_LIQU,
DBO.TRIM(TI_LIQN)+DBO.TRIM(TI_LIQN_DE),	 'AVERIAS',	 0,	 'BASICA',	 'AVERIAS STB',	 'BA',	 'AVERIAS',	 'AVERIAS STB',	 0,
' ',	 ' ',	 ' ',	 ' ',	 ' ',	 COD_UNICO,	 1,	 DBO.TRIM(TI_LIQN)+DBO.TRIM(TI_LIQN_DE)
FROM STB_FINAL

GO


ALTER TABLE DATA1908 ALTER COLUMN FECEJE NVARCHAR(255)
ALTER TABLE DATA1908 ALTER COLUMN DESCRIPT NVARCHAR(255)
ALTER TABLE DATA1908 ALTER COLUMN MOV NVARCHAR(255)
ALTER TABLE DATA1908 ALTER COLUMN PLAYA NVARCHAR(255)
ALTER TABLE DATA1908 ALTER COLUMN N_NEGOCIO NVARCHAR(255)
ALTER TABLE DATA1908 ALTER COLUMN NEG_NUE NVARCHAR(255)

GO

--**************************************************************************************
-- CARGA_INFANCIAS_DUO_A_DATA

UPDATE INF_ADSL
SET CONTRATA = 'COBRA'
WHERE SUBSTRING(CODCIP,1,2) = 'AB'

GO

UPDATE INF_ADSL
SET CONTRATA = 'LARI'
WHERE SUBSTRING(CODCIP,1,2) = 'LA'

GO

UPDATE INF_ADSL
SET CONTRATA = 'DOMINION'
WHERE SUBSTRING(CODCIP,1,2) = 'DO'

GO

UPDATE INF_ADSL
SET CONTRATA = 'CALATEL'
WHERE SUBSTRING(CODCIP,1,2) = 'CA'

GO

UPDATE INF_ADSL
SET AREA = 'P'
WHERE CMDF IN ('HUAL', 'CHAN')

GO

UPDATE INF_ADSL
SET ZON = 'CHB'
WHERE CMDF IN ('HUAL', 'CHAN')

GO
--------------------------------------------------------

UPDATE INF_ADSL
SET ZON = 'PRO'
WHERE AREA = 'P'

GO

UPDATE INF_ADSL
SET ZON = 'LIM'
WHERE AREA = 'L'

GO

-- CUANDO EN EL SEEK ES UN VALOR UTILIZAR UN UPDATE-JOIN CON WHERE = VALOR

-- BAREMO TOTAL *0.75
UPDATE A
SET A.DESC_UNI = 'INFANCIA -75%',
    A.BAR_UNI = B.BAR_UNI,
    A.BAR_TOT = B.BAR_UNI
FROM data1908 A JOIN UNIDADES B ON A.COD_UNI = B.COD_UNI
WHERE B.COD_UNI = '72310-0'

GO

UPDATE A
SET A.PRECIO = B.PRECIO,
	A.MONTO = A.BAR_TOT*A.PRECIO*-.75,
	A.OPEX = A.BAR_TOT*A.PRECIO*-.75
FROM data1908 A JOIN PRECIOS B ON A.CONTRA = B.CONTRA AND A.ZONAL = B.ZONAL

GO

UPDATE A
SET A.CZONAL = B.CZONAL,
	A.JEFATURA = B.JEF_CMR,
	A.ZONAL_BONO = B.ZONAL_BONO,
	A.JEFA_MAT = B.JEFA_MAT
FROM data1908 A JOIN JEFATURAS_REGIONES B ON A.CMDF_NODO = B.MDF

GO

INSERT INTO data1908 (CECO ,	COD_CUENTA ,	AF ,	DESCTA ,	TIPO ,	DEFINICION ,	SOCIEDAD ,	CCONTR ,	CONTRA ,	ORDEN_OT ,	RUTAC ,	CODREQ ,
CZONAL ,	CMDF_NODO ,	MOV_MAT ,	INS_CODCLI ,	TIPREQ ,	CODMOTV ,	NROPLANO ,	FECEJE ,	DESCRIPT ,	MOV ,	PLAYA ,	N_NEGOCIO ,	NEG_NUE ,
ACT_MAT ,	--MOV_MAT ,
ACTIVIDAD ,	TELEFONO ,	PREFIJO ,	CODSER ,	CODMOV ,	TSPEEDYACT ,	MODALACT ,	IND_PAQ ,	CANT ,	COD_ACT
)
SELECT  (SELECT CECO FROM CUENTA WHERE NEGOCIO = 'SPEEDY' AND MOV = 'AVERIAS')
,	 (SELECT COD_CUENTA FROM CUENTA WHERE NEGOCIO = 'SPEEDY' AND MOV = 'AVERIAS')
,	 (SELECT AF FROM CUENTA WHERE NEGOCIO = 'SPEEDY' AND MOV = 'AVERIAS')
,	 (SELECT DESCTA FROM CUENTA WHERE NEGOCIO = 'SPEEDY' AND MOV = 'AVERIAS'),	 'BUCLE',	 'OPEX',	 'TDP',	 CONTRA_TEC
,	 CONTRATA,	 SUBSTRING(CO_UNICO,4,7),	 0,	 0,	 ZON,	 CMDF,	 'AVERIAS',	 0,	 ' ',	 ' ',	 ' ',	 FE_LIQU
,	 DBO.TRIM(TI_LIQN)+DBO.TRIM(TI_LIQN_DE),	 'AVERIAS',	 0,	 'BASICA',	 'AVERIAS ADSL',	 'TB',	 --'AVERIAS',
'AVERIAS ADSL',
0,	 ' ',	 ' ',	 ' ',	 ' ',	 ' ',	 CO_UNICO,	 1,	 DBO.TRIM(TPEDIDO)
FROM INF_ADSL

GO

UPDATE INF_STB
SET CONTRATA = 'COBRA'
WHERE SUBSTRING(DBO.TRIM(CODCIP),1,2) = 'AB'

GO

UPDATE INF_STB
SET CONTRATA = 'LARI'
WHERE SUBSTRING(DBO.TRIM(CODCIP),1,2) = 'LA'

GO

UPDATE INF_STB
SET CONTRATA = 'DOMINION'
WHERE SUBSTRING(DBO.TRIM(CODCIP),1,2) = 'DO'

GO

UPDATE INF_STB
SET CONTRATA = 'CALATEL'
WHERE SUBSTRING(DBO.TRIM(CODCIP),1,2) = 'CA'

GO

UPDATE INF_STB
SET AREA = 'P'
WHERE CMDF IN ('HUAL', 'CHAN')

GO

UPDATE INF_STB
SET ZON = 'CHB'
WHERE CMDF IN ('HUAL', 'CHAN')

GO

-- CUANDO EN EL SEEK ES UN VALOR UTILIZAR UN UPDATE-JOIN CON WHERE = VALOR
-- Poner el baremo al 75%
UPDATE A
SET A.DESC_UNI = 'INFANCIA -75%',
	A.COD_UNI = B.COD_UNI,
    A.BAR_UNI = B.BAR_UNI,
    A.BAR_TOT = B.BAR_UNI
FROM data1908 A JOIN UNIDADES B ON A.COD_UNI = B.COD_UNI
WHERE B.COD_UNI = '72310-0'

GO

-- CUANDO EN EL SEEK SEA UNA COLUMNA O MAS UTILIZAR UN UPDATE-JOIN SIN WHERE
UPDATE A
SET A.PRECIO = B.PRECIO,
A.MONTO = A.BAR_TOT*A.PRECIO*-.75,
A.OPEX = A.BAR_TOT*A.PRECIO*-.75
FROM data1908 A JOIN PRECIOS B ON A.CONTRA = B.CONTRA AND A.ZONAL = B.ZONAL

GO

UPDATE A
SET A.CZONAL = B.CZONAL,
	A.JEFATURA = B.JEF_CMR,
	A.ZONAL_BONO = B.ZONAL_BONO,
	A.JEFA_MAT = B.JEFA_MAT
FROM data1908 A JOIN JEFATURAS_REGIONES B ON A.CMDF_NODO = B.MDF AND A.ZONAL = B.ZONAL

GO


INSERT INTO data1908 (CECO ,	COD_CUENTA ,	AF ,	DESCTA ,	TIPO ,	DEFINICION ,	SOCIEDAD ,	CCONTR ,	CONTRA ,	ORDEN_OT ,
RUTAC ,	CODREQ ,	CZONAL ,	CMDF_NODO ,	--MOV_MAT
INS_CODCLI ,	TIPREQ ,	CODMOTV ,	NROPLANO ,	FECEJE ,	DESCRIPT ,	MOV ,
PLAYA ,	N_NEGOCIO ,	NEG_NUE ,	ACT_MAT ,	MOV_MAT ,	ACTIVIDAD ,	TELEFONO ,	PREFIJO ,	CODSER ,	CODMOV ,	TSPEEDYACT ,	MODALACT ,
IND_PAQ ,	CANT ,	COD_ACT
)
SELECT (SELECT CECO FROM CUENTA WHERE NEGOCIO = 'SPEEDY' AND MOV = 'AVERIAS')
,	 (SELECT COD_CUENTA FROM CUENTA WHERE NEGOCIO = 'SPEEDY' AND MOV = 'AVERIAS')
,	 (SELECT AF FROM CUENTA WHERE NEGOCIO = 'SPEEDY' AND MOV = 'AVERIAS')
,	 (SELECT DESCTA FROM CUENTA WHERE NEGOCIO = 'SPEEDY' AND MOV = 'AVERIAS'),	 'BUCLE',	 'OPEX',	 'TDP',	 EECC
,	 CONTRATA,	 SUBSTRING(CO_UNICO,4,7),	 0,	 0,	 ZON,	 CMDF,	 --'AVERIAS'
0,	 ' ',	 ' ',	 ' ',	 FE_LIQU,
DBO.TRIM(TI_LIQN)+DBO.TRIM(TI_LIQN_DE),	 'AVERIAS',	 0,	 'BASICA',	 'AVERIAS STB',	 'TB',	 'AVERIAS',	 'AVERIAS STB',	 0,
' ',	 ' ',	 ' ',	 ' ',	 ' ',	 CO_UNICO,	 1,	 DBO.TRIM(TPEDIDO)
FROM INF_STB


GO

--*********************************************************************************************
-- CARGA_REITERADAS_DUO_A_DATA
-- DATA1909
 ALTER TABLE REIT_ADSL ADD CONTRATA NVARCHAR(255)

GO

UPDATE REIT_ADSL
SET CONTRATA = 'COBRA'
WHERE CONTRA_TEC = 'AB'

GO

UPDATE REIT_ADSL
SET CONTRATA = 'LARI'
WHERE CONTRA_TEC = 'LA'

GO

UPDATE REIT_ADSL
SET CONTRATA = 'DOMINION'
WHERE CONTRA_TEC = 'DO'

GO

UPDATE REIT_ADSL
SET CONTRATA = 'CALATEL'
WHERE CONTRA_TEC = 'CA'

GO

UPDATE REIT_ADSL
SET AREA = 'P'
WHERE CO_MDF IN ('HUAL', 'CHAN')

GO

UPDATE REIT_ADSL
SET ZON = 'CHB'
WHERE CO_MDF IN ('HUAL', 'CHAN')

GO

UPDATE REIT_ADSL
SET ZON = 'PRO'
WHERE AREA = 'P'

GO

UPDATE REIT_ADSL
SET ZON = 'LIM'
WHERE AREA = 'L'

GO

UPDATE A
SET A.COD_UNI = B.COD_UNI,
	A.DESC_UNI = 'REITERADA -75%',
    A.BAR_UNI = B.BAR_UNI,
    A.BAR_TOT = B.BAR_UNI
FROM data1908 A JOIN UNIDADES B ON A.COD_UNI = B.COD_UNI
WHERE B.COD_UNI = '72310-0'

GO

-- CUANDO EN EL SEEK SEA UNA COLUMNA O MAS UTILIZAR UN UPDATE-JOIN SIN WHERE
UPDATE A
SET A.PRECIO = B.PRECIO,
A.MONTO = A.BAR_TOT*A.PRECIO*-.75,
A.OPEX = A.BAR_TOT*A.PRECIO*-.75
FROM data1908 A JOIN PRECIOS B ON A.CONTRA = B.CONTRA AND A.ZONAL = B.ZONAL

GO

UPDATE A
SET A.CZONAL = B.CZONAL,
	A.JEFATURA = B.JEF_CMR,
	A.ZONAL_BONO = B.ZONAL_BONO,
	A.JEFA_MAT = B.JEFA_MAT
FROM data1908 A JOIN JEFATURAS_REGIONES B ON A.CMDF_NODO = B.MDF

GO

ALTER TABLE REIT_ADSL ALTER COLUMN CODAVERIA NVARCHAR(255)

INSERT INTO data1908 (CECO ,	COD_CUENTA ,	AF ,	DESCTA ,	TIPO ,	DEFINICION ,	SOCIEDAD ,	CCONTR ,	CONTRA ,
ORDEN_OT ,	RUTAC ,	CODREQ ,
CZONAL ,	CMDF_NODO ,
INS_CODCLI ,	TIPREQ ,	CODMOTV ,	NROPLANO ,	FECEJE ,	DESCRIPT ,	MOV ,	PLAYA ,	N_NEGOCIO ,	NEG_NUE ,	ACT_MAT ,	MOV_MAT ,	ACTIVIDAD ,
TELEFONO ,	PREFIJO ,	CODSER ,	CODMOV ,	TSPEEDYACT ,	MODALACT ,	IND_PAQ ,	CANT ,	COD_ACT
)
SELECT  (SELECT CECO FROM CUENTA WHERE NEGOCIO = 'SPEEDY' AND MOV = 'AVERIAS')
,	 (SELECT COD_CUENTA FROM CUENTA WHERE NEGOCIO = 'SPEEDY' AND MOV = 'AVERIAS')
,	 (SELECT AF FROM CUENTA WHERE NEGOCIO = 'SPEEDY' AND MOV = 'AVERIAS')
,	 (SELECT DESCTA FROM CUENTA WHERE NEGOCIO = 'SPEEDY' AND MOV = 'AVERIAS'),	 'BUCLE',	 'OPEX',	 'TDP',	 CONTRA_TEC
,	CONTRATA,
SUBSTRING(CODAVERIA,4,7),	 0,	 0,	 ZON,	 CO_MDF,
0,	 ' ',	 ' ',	 ' ',	 FE_LIQU,
DBO.TRIM(TI_LIQN)+DBO.TRIM(RE_TI_LIQN),	 'AVERIAS',	 0,	 'BASICA',	 'AVERIAS ADSL',	 'TB',	 'AVERIAS',	 'AVERIAS ADSL',
0,	 ' ',	 ' ',	 ' ',	 ' ',	 ' ',	 CODAVERIA,	 1,	 DBO.TRIM(TIPOLINEA)
FROM REIT_ADSL

GO

ALTER TABLE REIT_STB ADD CONTRATA NVARCHAR(255)


UPDATE REIT_STB
SET CONTRATA = 'COBRA'
WHERE DBO.TRIM(CONTRA_TEC) = 'AB'

GO

UPDATE REIT_STB
SET CONTRATA = 'LARI'
WHERE DBO.TRIM(CONTRA_TEC) = 'LA'

GO

UPDATE REIT_STB
SET CONTRATA = 'DOMINION'
WHERE DBO.TRIM(CONTRA_TEC) = 'DO'

GO

UPDATE REIT_STB
SET CONTRATA = 'CALATEL'
WHERE DBO.TRIM(CONTRA_TEC) = 'CA'

GO

UPDATE REIT_STB
SET AREA = 'P'
WHERE CO_MDF IN ('HUAL', 'CHAN')

GO

UPDATE REIT_STB
SET ZON = 'CHB'
WHERE CO_MDF IN ('HUAL', 'CHAN')

GO

-- CUANDO EN EL SEEK ES UN VALOR UTILIZAR UN UPDATE-JOIN CON WHERE = VALOR
UPDATE A
SET A.DESC_UNI = 'REITERADA -75%',
	A.COD_UNI = B.COD_UNI,
    A.BAR_UNI = B.BAR_UNI,
    A.BAR_TOT = B.BAR_UNI
FROM data1908 A JOIN UNIDADES B ON A.COD_UNI = B.COD_UNI
WHERE B.COD_UNI = '72310-0'

GO

-- CUANDO EN EL SEEK SEA UNA COLUMNA O MAS UTILIZAR UN UPDATE-JOIN SIN WHERE
UPDATE A
SET A.PRECIO = B.PRECIO,
A.MONTO = A.BAR_TOT*A.PRECIO*-.75, -- VERIFICAR
A.OPEX = A.BAR_TOT*A.PRECIO*-.75
FROM data1908 A JOIN PRECIOS B ON A.CONTRA = B.CONTRA AND A.ZONAL = B.ZONAL

GO

UPDATE A
SET A.CZONAL = B.CZONAL,
	A.JEFATURA = B.JEF_CMR,
	A.ZONAL_BONO = B.ZONAL_BONO,
	A.JEFA_MAT = B.JEFA_MAT
FROM data1908 A JOIN JEFATURAS_REGIONES B ON A.CMDF_NODO = B.MDF AND A.ZONAL = B.ZONAL

GO

ALTER TABLE REIT_STB ALTER COLUMN CODAVERIA NVARCHAR(255)

-- VERIFICAR EL CAMPO CODAVERIA !!!!!!!!!!! -- **********************************************************

INSERT INTO data1908 (CECO ,	COD_CUENTA ,	AF ,	DESCTA ,	TIPO ,	DEFINICION ,	SOCIEDAD ,	CCONTR ,	CONTRA ,	ORDEN_OT ,	RUTAC ,	CODREQ ,
CZONAL ,	CMDF_NODO ,
INS_CODCLI ,	TIPREQ ,	CODMOTV ,	NROPLANO ,	FECEJE ,	DESCRIPT ,	MOV ,	PLAYA ,	N_NEGOCIO ,	NEG_NUE ,	ACT_MAT ,	MOV_MAT ,	ACTIVIDAD ,
TELEFONO ,	PREFIJO ,	CODSER ,	CODMOV ,	TSPEEDYACT ,	MODALACT ,	IND_PAQ ,	CANT ,	COD_ACT
)
SELECT  (SELECT CECO FROM CUENTA WHERE NEGOCIO = 'SPEEDY' AND MOV = 'AVERIAS')
,	 (SELECT COD_CUENTA FROM CUENTA WHERE NEGOCIO = 'SPEEDY' AND MOV = 'AVERIAS')
,	 (SELECT AF FROM CUENTA WHERE NEGOCIO = 'SPEEDY' AND MOV = 'AVERIAS')
,	 (SELECT DESCTA FROM CUENTA WHERE NEGOCIO = 'SPEEDY' AND MOV = 'AVERIAS'),	 'BUCLE',	 'OPEX',	 'TDP',	CONTRA_TEC
,	 CONTRATA,	 SUBSTRING(CODAVERIA,4,7),	 0,	 0,	 ZON,	 CO_MDF,
0,	 ' ',	 ' ',	 ' ',	 FE_LIQU,
DBO.TRIM(TI_LIQN)+DBO.TRIM(RE_TI_LIQN),	 'AVERIAS',	 0,	 'BASICA',	 'AVERIAS STB',	 'TB',	 'AVERIAS',	 'AVERIAS STB',	 0,
' ',	 ' ',	 ' ',	 ' ',	 ' ',	 CODAVERIA,	 1,	 DBO.TRIM(TIPOLINEA)
FROM REIT_STB

GO

SELECT COUNT(*) 'FILAS ADSL_FINAL' FROM ADSL_FINAL
SELECT COUNT(*) 'FILAS STB_FINAL' FROM STB_FINAL
-- SELECT COUNT(*) 'FILAS INF_ADSL' FROM INF_ADSL
-- SELECT COUNT(*) 'FILAS INF_STB' FROM INF_STB
SELECT COUNT(*) 'FILAS REIT_ADSL' FROM REIT_ADSL
SELECT COUNT(*) 'FILAS REIT_STB' FROM REIT_STB;

SELECT TELEFONO, COUNT(*) FROM ADSL_FINAL GROUP BY TELEFONO

/*
ADSL_FINAL=23698,
STB_FINAL=21314,
REIT_ADSL=4729,
REIT_STB=2946
*/

/* 23/10/2019
ADSL_FINAL=23482,
STB_FINAL=21646,
REIT_ADSL=5387,
REIT_STB=3313
*/
