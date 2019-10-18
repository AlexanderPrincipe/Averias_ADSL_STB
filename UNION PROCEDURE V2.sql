
--DROP PROCEDURE AVERIAS_CALCULO
DROP TABLE AVE_TABLA

CREATE PROCEDURE AVERIAS_CALCULO
AS
 --*******************************************************************************************************************************
 --********************************************************************************************************************************
------- CARGA AVERIAS A DATA -----------------------------------------------------------------------------------------------------
--********************************************************************************************************************************
-- BORRAR AVERIAS HFC, DTH Y GPON
DELETE FROM data1908
WHERE NEG_NUE IN ('AVERIAS HFC', 'AVERIAS DTH', 'AVERIAS GPON')

GO

-- ACTUALIZAR DE EZENTIS A CALATEL
UPDATE INDICA_PAIS
SET CONTRA = 'CALATEL'
WHERE DBO.TRIM(CONTRA) = 'EZENTIS';

GO

-- CREACION DE AVE

SELECT * INTO AVE_TABLA FROM (
SELECT * FROM INDICA_PAIS WHERE SUBSTRING(DBO.TRIM(SERVICIO),1,3) = 'DTH' AND INF_CERT = 0 AND REITCERT30 = 0 AND SUBSTRING(DBO.TRIM(APAGAR),1,8) = 'RED CLIE'
UNION
SELECT * FROM INDICA_PAIS WHERE SUBSTRING(DBO.TRIM(SERVICIO),1,4) = 'GPON' AND INF_CERT = 0 AND REITCERT30 = 0 AND SUBSTRING(DBO.TRIM(APAGAR),1,8) = 'RED CLIE'
UNION
SELECT * FROM INDICA_PAIS WHERE SUBSTRING(DBO.TRIM(SERVICIO),1,5) = 'MOVIS' AND SUBSTRING(DBO.TRIM(APAGAR),1,8) = 'RED CLIE'
) A

GO

-- APPEND BLANK = INSERT INTO---------------------------------------
-- REPLACE

-- MEJORA DEL CODIGO TOXICO
-- CREAMOS COLUMNAS EN LA MISMA AVE_TABLA, HACEMOS LOS UPDATES EN AVE_TABLA, LUEGO SE INSERTARA LAS COLUMNAS CREADAS Y UPDATEADAS A LA TABLA DATA
ALTER TABLE AVE_TABLA ADD N_NEGOCIO NVARCHAR(255)
ALTER TABLE AVE_TABLA ADD NEG_NUE NVARCHAR(255)
ALTER TABLE AVE_TABLA ADD ACT_MAT NVARCHAR(255)
ALTER TABLE AVE_TABLA ADD ACTIVIDAD NVARCHAR(255)
ALTER TABLE AVE_TABLA ADD NEGO_BONO NVARCHAR(255)

GO

UPDATE AVE_TABLA
SET N_NEGOCIO = 'DTH'
WHERE SUBSTRING(DBO.TRIM(SERVICIO),1,3) = 'DTH'

GO

UPDATE AVE_TABLA
SET NEG_NUE = 'AVERIAS DTH'
WHERE SUBSTRING(DBO.TRIM(SERVICIO),1,3) = 'DTH'

GO

UPDATE AVE_TABLA
SET ACT_MAT = 'DTH'
WHERE SUBSTRING(DBO.TRIM(SERVICIO),1,3) = 'DTH'

GO

UPDATE AVE_TABLA
SET ACTIVIDAD = 'AVERIAS DTH'
WHERE SUBSTRING(DBO.TRIM(SERVICIO),1,3) = 'DTH'

GO
---------------------------------------------------------

UPDATE AVE_TABLA
SET N_NEGOCIO = 'GPON'
WHERE SUBSTRING(DBO.TRIM(SERVICIO),1,4) = 'GPON'

GO

UPDATE AVE_TABLA
SET NEG_NUE = 'AVERIAS GPON'
WHERE SUBSTRING(DBO.TRIM(SERVICIO),1,4) = 'GPON'

GO

UPDATE AVE_TABLA
SET ACT_MAT = 'GPON'
WHERE SUBSTRING(DBO.TRIM(SERVICIO),1,4) = 'GPON'

GO

UPDATE AVE_TABLA
SET ACTIVIDAD = 'AVERIAS GPON'
WHERE SUBSTRING(DBO.TRIM(SERVICIO),1,4) = 'GPON'

GO

UPDATE AVE_TABLA
SET NEGO_BONO = 'AVERIAS GPON'
WHERE SUBSTRING(DBO.TRIM(SERVICIO),1,4) = 'GPON'

GO
----------------------------------------------------

UPDATE AVE_TABLA
SET N_NEGOCIO = 'MOVISTAR'
WHERE SUBSTRING(DBO.TRIM(SERVICIO),1,8) = 'MOVISTAR'

GO

UPDATE AVE_TABLA
SET NEG_NUE = 'AVERIAS HFC'
WHERE SUBSTRING(DBO.TRIM(SERVICIO),1,8) = 'MOVISTAR'

GO

UPDATE AVE_TABLA
SET ACT_MAT = 'HFC'
WHERE SUBSTRING(DBO.TRIM(SERVICIO),1,8) = 'MOVISTAR'

GO

UPDATE AVE_TABLA
SET ACTIVIDAD = 'AVERIAS HFC'
WHERE SUBSTRING(DBO.TRIM(SERVICIO),1,8) = 'MOVISTAR'

GO

UPDATE AVE_TABLA
SET NEGO_BONO = 'AVERIAS HFC'
WHERE SUBSTRING(DBO.TRIM(SERVICIO),1,8) = 'MOVISTAR'

GO

-- LINEA 111 A 124-----------
UPDATE DATA1908
SET TELEFONO = 0, PREFIJO = NULL, CODSER = NULL, CODMOV = NULL, TSPEEDYACT = NULL, MODALACT =  NULL, CANT = 1

GO


ALTER TABLE AVE_TABLA ADD COD_NUE NVARCHAR(255)
ALTER TABLE AVE_TABLA ADD DESC_UNI NVARCHAR(255)
ALTER TABLE AVE_TABLA ADD MONTO INT
ALTER TABLE AVE_TABLA ADD COD_NUE NVARCHAR(255)
ALTER TABLE AVE_TABLA ADD OPEX_NUE INT

GO

UPDATE AVE_TABLA
SET COD_NUE = '7708-8'
WHERE SERVICIO = 'MOVISTAR1'

GO

UPDATE AVE_TABLA
SET DESC_UNI = 'REITERADA AL 25%',
	MONTO = ROUND(MONTO*.25,2),
	DESC_NUE = 'REITERADA AL 25%',
	OPEX_NUE = ROUND(MONTO_NUE*.25,2)
WHERE REITCERT30 = 1 AND SERVICIO = 'MOVISTAR1'

GO

UPDATE AVE_TABLA
SET DESC_UNI = 'INFANCIA AL 25%',
	MONTO = ROUND(MONTO*.25,2),
	DESC_NUE = 'INFANCIA AL 25%',
	OPEX_NUE = ROUND(MONTO*.25,2)
WHERE REITCERT30 = 0 AND SERVICIO = 'MOVISTAR1' AND INF_CERT = 1

GO



UPDATE AVE_TABLA
SET DESC_UNI = DESC_UNI,
	 MONTO = MONTO,
	DESC_NUE =  DESC_NUE,
	OPEX_NUE = OPEX_NUE
WHERE REITCERT30 = 0 AND INF_CERT = 0 AND SERVICIO = 'MOVISTAR1'

GO

UPDATE AVE_TABLA
SET OPEX_NUE = (SELECT DISTINCT MONTO_NUE FROM AVE_TABLA WHERE SERVICIO <> 'MOVISTAR1' AND SERVICIO LIKE '%DTH%'),
	DESC_NUE = (SELECT DISTINCT DESC_NUE FROM AVE_TABLA WHERE SERVICIO <> 'MOVISTAR1' AND SERVICIO LIKE '%DTH%')
WHERE SUBSTRING(DBO.TRIM(SERVICIO),1,3) = 'DTH' AND SERVICIO <> 'MOVISTAR1'

GO

/*
IF EXISTS (SELECT SERVICIO FROM AVE_VW WHERE SERVICIO <> 'MOVISTAR1')
	IF EXISTS (SELECT * FROM AVE_VW WHERE SUBSTRING(DBO.TRIM(SERVICIO),1,3) = 'DTH')
		UPDATE DATA1908
		SET DESC_NUE = (SELECT DISTINCT DESC_NUE FROM AVE_VW WHERE SERVICIO <> 'MOVISTAR1' AND SUBSTRING(DBO.TRIM(SERVICIO),1,3) = 'DTH')
			--OPEX_NUE = (SELECT OPEX_NUE FROM AVE_VW WHERE SERVICIO <> 'MOVISTAR1' AND SUBSTRING(DBO.TRIM(SERVICIO),1,3) = 'DTH')
*/
		-------------------------------------------------------------
-- **************************************** CERO COLUMNAS AFECTADAS REVISAR!!!! -****************************************
UPDATE AVE_TABLA
SET DESC_UNI = 'REITERADA',
	MONTO = (SELECT DISTINCT DESC_NUE FROM AVE_TABLA WHERE SERVICIO <> 'MOVISTAR1' AND SERVICIO LIKE '%DTH%' AND REITCERT30 = 1)
WHERE SUBSTRING(DBO.TRIM(SERVICIO),1,3) = 'DTH' AND SERVICIO <> 'MOVISTAR1' AND REITCERT30 = 1

GO


/*
		IF EXISTS (SELECT REITCERT30 FROM AVE_VW WHERE REITCERT30 = 1)
			UPDATE DATA1908
			SET DESC_UNI = 'REITERADA',
			MONTO = (SELECT ROUND(MONTO_NUE*.25,2) FROM AVE_VW WHERE SERVICIO LIKE '%DTH%' AND SERVICIO <> 'MOVISTAR' AND REITCERT30 = 1)
*/

--************************************************ CERO COLUMNAS AFECTADAS REVISAR!!!! --*****************************************************
UPDATE AVE_TABLA
SET DESC_UNI = 'INFANCIA',
	MONTO = (SELECT DISTINCT ROUND(MONTO_NUE*.25,2) FROM AVE_TABLA WHERE SUBSTRING(DBO.TRIM(SERVICIO),1,3) = 'DTH' AND SERVICIO <> 'MOVISTAR1' AND REITCERT30 = 0 AND INF_CERT = 1)
WHERE SUBSTRING(DBO.TRIM(SERVICIO),1,3) = 'DTH' AND SERVICIO <> 'MOVISTAR1' AND REITCERT30 = 0 AND INF_CERT = 1

GO

/*
		ELSE
			IF EXISTS (SELECT INF_CERT FROM AVE_VW WHERE INF_CERT = 1)
				UPDATE DATA1908
				SET DESC_UNI = 'INFANCIA',
					MONTO = (SELECT ROUND(MONTO_NUE*.25,2) FROM AVE_VW WHERE SERVICIO LIKE '%DTH%' AND SERVICIO <> 'MOVISTAR' AND REITCERT30 = 0)
*/

-- CODIGO NNECESARIO | SIRVE COMO GUIA | LINEA 165-166 DE CARGA_AVERIAS_A_DATA.PRG
UPDATE AVE_TABLA
SET DESC_UNI = DESC_UNI,
	MONTO = MONTO
WHERE SERVICIO LIKE '%DTH%' AND SERVICIO <> 'MOVISTAR1' AND REITCERT30 = 0 AND INF_CERT = 0

GO

/*
			ELSE
				UPDATE DATA1908
				SET DESC_UNI = (SELECT DESC_UNI FROM AVE_VW),
					MONTO = (SELECT MONTO FROM AVE_VW)
*/

/*
 IF EXISTS (SELECT SERVICIO FROM AVE_VW WHERE SERVICIO <> 'MOVISTAR1')
	IF EXISTS (SELECT * FROM AVE_VW WHERE SUBSTRING(DBO.TRIM(SERVICIO),1,3) = 'DTH')
		UPDATE DATA1908
		SET DESC_NUE = (SELECT DISTINCT DESC_NUE FROM AVE_VW WHERE SERVICIO <> 'MOVISTAR1' AND SUBSTRING(DBO.TRIM(SERVICIO),1,3) = 'DTH')
			--OPEX_NUE = (SELECT OPEX_NUE FROM AVE_VW WHERE SERVICIO <> 'MOVISTAR1' AND SUBSTRING(DBO.TRIM(SERVICIO),1,3) = 'DTH')

		IF EXISTS (SELECT REITCERT30 FROM AVE_VW WHERE REITCERT30 = 1)
			UPDATE DATA1908
			SET DESC_UNI = 'REITERADA',
				MONTO = (SELECT ROUND(MONTO_NUE*.25,2) FROM AVE_VW)
		ELSE
			IF EXISTS (SELECT INF_CERT FROM AVE_VW WHERE INF_CERT = 1)
				UPDATE DATA1908
				SET DESC_UNI = 'INFANCIA',
					MONTO = (SELECT ROUND(MONTO_NUE*.25,2) FROM AVE_VW)
			ELSE
				UPDATE DATA1908
				SET DESC_UNI = (SELECT DESC_UNI FROM AVE_VW),
					MONTO = (SELECT MONTO FROM AVE_VW) --> fila 166
*/

UPDATE AVE_TABLA
SET DESC_UNI= DESC_UNI,
	MONTO = MONTO,
	OPEX_NUE = OPEX_NUE,
	DESC_NUE = DESC_NUE
WHERE SERVICIO <> 'MOVISTAR1' AND SERVICIO NOT LIKE '%DTH%' AND SERVICIO LIKE '%GPON%'

GO

/*
 IF EXISTS (SELECT SERVICIO FROM AVE_VW WHERE SERVICIO <> 'MOVISTAR1')
	IF EXISTS (SELECT * FROM AVE_VW WHERE SUBSTRING(DBO.TRIM(SERVICIO),1,3) <> 'DTH')
		IF EXISTS (SELECT * FROM AVE_VW WHERE SUBSTRING(DBO.TRIM(SERVICIO),1,4) = 'GPON')
			UPDATE DATA1908
			SET DESC_UNI = (SELECT DESC_UNI FROM AVE_VW),
				MONTO = (SELECT MONTO FROM AVE_VW),
				OPEX_NUE = (SELECT MONTO_NUE FROM AVE_VW),
				DESC_NUE = (SELECT DESC_NUE FROM AVE_VW)
*/



/*
 select jefa
        if seek(cam.codnod)
           A.czonal = jefa.czonal
           A.jefatura   = jefa.jef_cmr
           if cam.servicio='Movistar'
              A.zonal_bono = jefa.zonal_bono
           endif
           A.jefa_mat   = jefa.jefa_mat
           IF JEFA.JEFA_MAT='LIMA'
              IF A.CONTRA='COBRA'
                 A.JEFA_MAT = 'COLIM'
              ELSE
              IF A.CONTRA='CALATEL'
                 A.JEFA_MAT = 'CALIM'
              ELSE
              IF A.CONTRA='LARI'
                 A.JEFA_MAT = 'LALIM'
                 ELSE
                 IF A.CONTRA='DOMINION'
                    A.JEFA_MAT = 'DOLIM'
                 ENDIF
              ENDIF
              ENDIF
              ENDIF
           ENDIF
          endif
    select cam
endscan
*/


-- INSERTAR FILAS DE LA TABLA AVE A LA TABLA DATA1 (DATA1908)
-- SE CORRE CUANDO AVE_TABLA ESTA ACTUALIZADO
INSERT INTO data1908 (CECO ,	    COD_CUENTA ,	    AF ,	    DESCTA ,	    TIPO ,	    DEFINICION ,	    SOCIEDAD ,	    CCONTR ,	    CONTRA ,	    ORDEN_OT ,	    RUTAC ,	    CODREQ ,	    CZONAL ,	    CMDF_NODO ,	    MOV_MAT ,	    INS_CODCLI ,	    TIPREQ ,	    CODMOTV ,	    NROPLANO ,	    FECEJE ,	    DESCRIPT ,	    MOV ,	    PLAYA ,	    telefono ,	    prefijo   ,	    codser    ,	    codmov    ,	    tspeedyact  ,	    modalact ,	    cant    ,	    cod_act ,	    cod_uni ,	    bar_uni_n ,	    pbar_nue  ,	    precio_nue, OPEX_NUE, BAR_UNI,BAR_TOT, PRECIO
)
SELECT  CECO,	 COD_CUENTA,	 AF,	 DESCTA,	 'BUCLE',	 'OPEX',	 'TMM',	 CODCTR,	 CONTRA,	 NROOT,	 RUTAC,	 CODREQ,	 CZONAL,	 CODNOD,	 'AVERIAS',	 CODCLI,	 TIPREQ,	 MOTGEN,	 PLANO,	 FECLIQ,	 DBO.TRIM(LIQ_DET)+' '+DBO.TRIM(COD_DET)+'-'+DBO.TRIM(COD_DES),	 'AVERIAS',	 OPE_PLAYAS,	 0,	 ' ',	 ' ',	 ' ',	 '  ',	 '  ',	 1,	 DBO.TRIM(tipreq)+DBO.TRIM(motgen),	 cod_uni,	 pbar_nue,	 pbar_nue,	 precio_nue,	 monto_nue, BAR_TOT, BAR_TOT, PRECIO
FROM AVE_TABLA

GO

UPDATE A
SET A.CZONAL = C.czonal,
	A.JEFATURA = C.jef_cmr,
	A.JEFA_MAT = C.jefa_mat
FROM data1908 A JOIN AVE_TABLA B ON A.CMDF_NODO = B.codnod JOIN jefaturas_regiones C ON B.CODNOD = C.MDF

GO

UPDATE A
SET A.ZONAL_BONO = C.zonal_bono
FROM data1908 A JOIN AVE_TABLA B ON A.CMDF_NODO = B.codnod JOIN jefaturas_regiones C ON B.CODNOD = C.MDF
WHERE SERVICIO LIKE '%MOVISTAR%'

GO
-- ************************************************************* LINEA 904

UPDATE A
SET A.ZONAL_BONO = C.zonal_bono
FROM data1908 A JOIN AVE_TABLA B ON A.CMDF_NODO = B.codnod JOIN jefaturas_regiones C ON B.CODNOD = C.MDF
WHERE C.jefa_mat = 'LIMA' AND A.CONTRA IS NULL

GO
--*******************************************************************
--*******************************************************************
--*******************************************************************
--*******************************************************************
	-- CARGA_AVERIAS_DUO_A_DATA

-- EXEC CARGA_AV_STB

-- ALTER TABLE ADSL_FINAL ADD CONTRATA NVARCHAR(255)
-- SELECT CONTRATA, COUNT(*) FROM ADSL_FINAL GROUP BY CONTRATA
-- SELECT CTECNICO, CONTRATA FROM ADSL_FINAL WHERE CONTRATA IS NULL

-- CREATE PROCEDURE CARGA_AV_ADSL
-- AS

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
SELECT DESCTA FROM CUENTA WHERE NEGOCIO = 'SPEEDY' AND MOV = 'AVERIAS' --DESCTA�
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
-- VISUAL FOX PRO = CODIGO T�XICO
/*
IF EXISTS (SELECT * FROM ADSL_FINAL WHERE A = 'P')
	UPDATE data1908
	SET ZONAL = 'PRO'
	ELSE
		IF	EXISTS (SELECT * FROM ADSL_FINAL WHERE A = 'L')
			UPDATE data1908
			SET ZONAL = 'LIM'
*/

/*PRUEBAS
CREATE TABLE TABLA1 (ID VARCHAR(50), NOMBRE NVARCHAR(50), EDAD INT)
CREATE TABLE TABLA2 (ID VARCHAR(50), NOMBRE NVARCHAR(50), EDAD INT)

INSERT INTO TABLA2 VALUES (3, 'LEONARDO VETRA', 55)

SELECT * FROM TABLA1;
SELECT * FROM TABLA2

BEGIN TRAN
IF EXISTS (SELECT * FROM TABLA1 WHERE ID = '2')
	UPDATE TABLA2
	SET EDAD = 23
	ELSE
		IF	EXISTS (SELECT * FROM TABLA1 WHERE ID= '1')
			UPDATE TABLA2
			SET EDAD = 40
ROLLBACK
*/

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
/*
BEGIN TRAN
UPDATE A
SET A.CECO = ' ',
	A.COD_CUENTA = ' ',
	A.AF = ' ',
	A.DESCTA = ' ',
	A.TIPO = 'BUCLE',
	A.DEFINICION = 'OPEX',
	A.SOCIEDAD = 'TDP',
	A.CCONTR = B.CODEECC,
	A.CONTRA = B.CONTRATA,
	A.ORDEN_OT = SUBSTRING(B.AVERIA,4,7),
	A.RUTAC = 0,
	A.CODREQ = 0,
	A.CZONAL = B.ZON,
	A.CMDF_NODO = B.MDF,
	--A.MOV_MAT = 'AVERIAS'
	A.INS_CODCLI = 0,
	A.TIPREQ = ' ',
	A.CODMOTV = ' ',
	A.NROPLANO = ' ',
	A.FECEJE = B.FECHA_LIQU,
	A.DESCRIPT = DBO.TRIM(B.codliq)+'-'+DBO.TRIM(B.coddetliq)+'-'+DBO.TRIM(B.ddescodliq),
	A.MOV = 'AVERIAS',
	A.PLAYA = 0,
	A.N_NEGOCIO = 'SPEEDY',
	A.NEG_NUE = 'AVERIAS ADSL',
	A.ACT_MAT = 'BA',
	A.MOV_MAT = 'AVERIAS',
	A.ACTIVIDAD = 'AVERIAS ADSL',
	A.TELEFONO = 0,
	A.PREFIJO = ' ',
	A.CODSER = ' ',
	A.CODMOV = ' ',
	A.TSPEEDYACT = ' ',
	A.MODALACT = B.DESMODA,
	A.IND_PAQ = B.AVERIA,
	A.CANT = 1
	--A.COD_ACT = DBO.TRIM(B..codliq)+'-'+DBO.TRIM(B.coddetliq)
FROM data1908 A JOIN ADSL_FINAL B ON 1 = 1
*/

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

GO

-- REVISAR LOS CAMPOS
UPDATE A
SET A.CZONAL = B.CZONAL,
	A.JEFATURA = B.JEF_CMR,
	A.ZONAL_BONO = B.ZONAL_BONO,
	A.JEFA_MAT = B.JEFA_MAT
FROM data1908 A JOIN JEFATURAS_REGIONES B ON A.CMDF_NODO = B.MDF

GO

/*
if seek('72300-2')
	       replace arch.cod_uni with uni.cod_uni
           replace arch.desc_uni with  uni.desc_uni
	       replace arch.bar_uni  with  uni.bar_uni
	       replace arch.bar_tot  with  uni.bar_uni
        endif

	    select pre
	         wcon=alltrim(arch.contra)+alltrim(arch.zonal)
	         if seek(wcon)
	            replace arch.precio with pre.precio
	            replace arch.monto  with arch.bar_tot*arch.precio
	            replace arch.OPEX  with arch.bar_tot*arch.precio
	         ELSE
	            replace arch.precio with 0
	         endif

	    select jefa
	        if seek(arch.cmdf_nodo)
	           replace arch.czonal with jefa.czonal
	           replace arch.jefatura   with jefa.jef_cmr
               replace arch.zonal_bono with jefa.zonal_bono
	           replace arch.jefa_mat   with jefa.jefa_mat
	         endif
	    select cam
	endscan
	*/

ALTER TABLE STB_FINAL ALTER COLUMN TI_LIQN_DE NVARCHAR(255)

-- ***********************************************
-- ERROR DATA TYPE VARCHAR TO FLOAT -- ***********************************************
INSERT INTO data1908 (CECO ,
COD_CUENTA ,	AF ,	DESCTA ,	TIPO ,	DEFINICION ,	SOCIEDAD ,	CCONTR ,	CONTRA ,	ORDEN_OT ,	RUTAC
,	CODREQ ,	CZONAL ,	CMDF_NODO ,	--MOV_MAT ,
INS_CODCLI ,	TIPREQ ,	CODMOTV ,	NROPLANO ,	FECEJE ,
DESCRIPT ,	MOV ,	PLAYA ,	N_NEGOCIO ,	NEG_NUE ,	ACT_MAT ,	MOV_MAT ,
ACTIVIDAD ,	TELEFONO ,	PREFIJO ,	CODSER ,	CODMOV ,	TSPEEDYACT ,	MODALACT ,
IND_PAQ ,	CANT ,	COD_ACT
)
SELECT  (SELECT CECO FROM CUENTA WHERE NEGOCIO = 'SPEEDY' AND MOV = 'AVERIAS')
,	 (SELECT COD_CUENTA FROM CUENTA WHERE NEGOCIO = 'SPEEDY' AND MOV = 'AVERIAS')
,	 (SELECT AF FROM CUENTA WHERE NEGOCIO = 'SPEEDY' AND MOV = 'AVERIAS')
,	 (SELECT DESCTA FROM CUENTA WHERE NEGOCIO = 'SPEEDY' AND MOV = 'AVERIAS'),	 'BUCLE',	 'OPEX',	 'TDP',	 EECC,
CONTRATA,	 SUBSTRING(COD_UNICO,4,7),	 0,	 0,	 ZONAL,	 MDF,	 'AVERIAS',	--0,
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

--ALTER TABLE STB_FINAL ADD CONTRATA NVARCHAR(255)

/*
BEGIN TRAN
UPDATE A
SET A.CECO = ' ',
	A.COD_CUENTA = ' ',
	A.AF = ' ',
	A.DESCTA = ' ',
	A.TIPO = 'BUCLE',
	A.DEFINICION = 'OPEX',
	A.SOCIEDAD = 'TDP',
	A.CCONTR = B.EECC,
	A.CONTRA = B.CONTRATA,
	A.ORDEN_OT = SUBSTRING(B.COD_UNICO,4,7),
	A.RUTAC = 0,
	A.CODREQ = 0,
	A.CZONAL = B.ZONAL,
	A.CMDF_NODO = B.MDF,
	--A.MOV_MAT = 'AVERIAS',
	A.INS_CODCLI = 0,
	A.TIPREQ = ' ',
	A.CODMOTV = ' ',
	A.NROPLANO = ' ',
	A.FECEJE = B.FECHA_LIQU,
	A.DESCRIPT = DBO.TRIM(B.TI_LIQN)+DBO.TRIM(B.TI_LIQN_DE),
	A.MOV = 'AVERIAS',
	A.PLAYA = 0,
	A.N_NEGOCIO = 'BASICA',
	A.NEG_NUE = 'AVERIAS STB',
	A.ACT_MAT = 'BA',
	A.MOV_MAT = 'AVERIAS',
	A.ACTIVIDAD = 'AVERIAS STB',
	A.TELEFONO = 0,
	A.PREFIJO = ' ',
	A.CODSER = ' ',
	A.CODMOV = ' ',
	A.TSPEEDYACT = ' ',
	A.MODALACT = ' ',
	A.IND_PAQ = B.COD_UNICO,
	A.CANT = 1,
	A.COD_ACT = DBO.TRIM(B.TI_LIQN)+DBO.TRIM(B.TI_LIQN_DE)
FROM data1908 A JOIN STB_FINAL B ON 1 = 1
*/


--**************************************************************************************
--**************************************************************************************
--**************************************************************************************
--**************************************************************************************

	-- CARGA_INFANCIAS_DUO_A_DATA
-- DATA1909

-- EXEC CARGA_AV_STB

-- ALTER TABLE ADSL_FINAL ADD CONTRATA NVARCHAR(255)
-- SELECT CONTRATA, COUNT(*) FROM ADSL_FINAL GROUP BY CONTRATA
-- SELECT CTECNICO, CONTRATA FROM ADSL_FINAL WHERE CONTRATA IS NULL

-- CREATE PROCEDURE CARGA_AV_ADSL
-- AS

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

/*
BEGIN TRAN
UPDATE A
SET A.CECO = ' ',
	A.COD_CUENTA = ' ',
	A.AF = ' ',
	A.DESCTA = ' ',
	A.TIPO = 'BUCLE',
	A.DEFINICION = 'OPEX',
	A.SOCIEDAD = 'TDP',
	A.CCONTR = B.CONTRA_TEC,
	A.CONTRA = B.CONTRATA,
	A.ORDEN_OT = SUBSTRING(B.COD_UNICO,4,7),
	A.RUTAC = 0,
	A.CODREQ = 0,
	A.CZONAL = B.ZONAL,
	A.CMDF_NODO = B.MDF,
	--A.MOV_MAT = 'AVERIAS',
	A.INS_CODCLI = 0,
	A.TIPREQ = ' ',
	A.CODMOTV = ' ',
	A.NROPLANO = ' ',
	A.FECEJE = B.FECHA_LIQU,
	A.DESCRIPT = DBO.TRIM(B.TI_LIQN)+DBO.TRIM(B.TI_LIQN_DE),
	A.MOV = 'AVERIAS',
	A.PLAYA = 0,
	A.N_NEGOCIO = 'BASICA',
	A.NEG_NUE = 'AVERIAS ADSL',
	A.ACT_MAT = 'TB',
	A.MOV_MAT = 'AVERIAS',
	A.ACTIVIDAD = 'AVERIAS ADSL',
	A.TELEFONO = 0,
	A.PREFIJO = ' ',
	A.CODSER = ' ',
	A.CODMOV = ' ',
	A.TSPEEDYACT = ' ',
	A.MODALACT = ' ',
	A.IND_PAQ = B.COD_UNICO,
	A.CANT = 1,
	A.COD_ACT = DBO.TRIM(B.TPEDIDO)
FROM data1908 A JOIN ADSL_FINAL B ON 1 = 1

*/

 ALTER TABLE STB_FINAL ADD CONTRATA NVARCHAR(255)

UPDATE INF_STB
SET CONTRATA = 'COBRA'
WHERE DBO.TRIM(EECC) = 'AB'

GO

UPDATE INF_STB
SET CONTRATA = 'LARI'
WHERE DBO.TRIM(EECC) = 'LA'

GO

UPDATE INF_STB
SET CONTRATA = 'DOMINION'
WHERE DBO.TRIM(EECC) = 'DO'

GO

UPDATE INF_STB
SET CONTRATA = 'CALATEL'
WHERE DBO.TRIM(EECC) = 'CA'

GO

UPDATE INF_STB
SET AREA = 'P'
WHERE CMDF IN ('HUAL', 'CHAN')

GO

UPDATE INF_STB
SET ZON = 'CHB' -- ZON
WHERE CMDF IN ('HUAL', 'CHAN')

GO

-- CUANDO EN EL SEEK ES UN VALOR UTILIZAR UN UPDATE-JOIN CON WHERE = VALOR
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
/*
BEGIN TRAN
UPDATE A
SET A.CECO = ' ',
	A.COD_CUENTA = ' ',
	A.AF = ' ',
	A.DESCTA = ' ',
	A.TIPO = 'BUCLE',
	A.DEFINICION = 'OPEX',
	A.SOCIEDAD = 'TDP',
	A.CCONTR = B.CONTRA_TEC,
	A.CONTRA = B.CONTRATA,
	A.ORDEN_OT = SUBSTRING(B.COD_UNICO,4,7),
	A.RUTAC = 0,
	A.CODREQ = 0,
	A.CZONAL = B.ZONAL,
	A.CMDF_NODO = B.MDF,
	--A.MOV_MAT = 'AVERIAS',
	A.INS_CODCLI = 0,
	A.TIPREQ = ' ',
	A.CODMOTV = ' ',
	A.NROPLANO = ' ',
	A.FECEJE = B.FECHA_LIQU,
	A.DESCRIPT = DBO.TRIM(B.TI_LIQN)+DBO.TRIM(B.TI_LIQN_DE),
	A.MOV = 'AVERIAS',
	A.PLAYA = 0,
	A.N_NEGOCIO = 'BASICA',
	A.NEG_NUE = 'AVERIAS STB',
	A.ACT_MAT = 'TB',
	A.MOV_MAT = 'AVERIAS',
	A.ACTIVIDAD = 'AVERIAS STB',
	A.TELEFONO = 0,
	A.PREFIJO = ' ',
	A.CODSER = ' ',
	A.CODMOV = ' ',
	A.TSPEEDYACT = ' ',
	A.MODALACT = ' ',
	A.IND_PAQ = B.COD_UNICO,
	A.CANT = 1,
	A.COD_ACT = DBO.TRIM(B.TPEDIDO)
FROM data1908 A JOIN STB_FINAL B ON 1 = 1

*/
--*********************************************************************************************
--*********************************************************************************************
--*********************************************************************************************
--*********************************************************************************************

	-- CARGA_REITERADAS_DUO_A_DATA
-- DATA1909

-- EXEC CARGA_AV_STB

-- ALTER TABLE REIT_ADSL ADD CONTRATA NVARCHAR(255)
-- ALTER TABLE REIT_ADSL ADD CONTRA_TEC NVARCHAR(255)
-- CREATE PROCEDURE CARGA_AV_ADSL
-- AS

ALTER TABLE REIT_ADSL ADD CONTRA_TEC NVARCHAR(255)
ALTER TABLE REIT_ADSL ADD CONTRATA NVARCHAR(255)

GO

-- REVISAR
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
--------------------------------------------------------
/*
if seek('SPEEDYAVERIAS')
       wceco=cuent.ceco
       wcod_cuenta=cuent.cod_cuenta
       waf=cuent.af
       wdescta=cuent.descta
    endif
*/

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

-- SELECT CONTRA, ZONAL, AVG(PRECIO) FROM PRECIOS GROUP BY CONTRA, ZONAL
-- SELECT CONTRA, ZONAL FROM PRECIOS WHERE CONTRA = 'ANOVO' AND ZONAL = 'LIM'

UPDATE A
SET A.CZONAL = B.CZONAL,
	A.JEFATURA = B.JEF_CMR,
	A.ZONAL_BONO = B.ZONAL_BONO,
	A.JEFA_MAT = B.JEFA_MAT
FROM data1908 A JOIN JEFATURAS_REGIONES B ON A.CMDF_NODO = B.MDF

GO

-- ARGUMENT DATA TYPE FLOAT IS INVALID FOR ARGUMENT 1 OF SUBSTRING FUNCTION
INSERT INTO data1908 (CECO ,	COD_CUENTA ,	AF ,	DESCTA ,	TIPO ,	DEFINICION ,	SOCIEDAD ,	CCONTR ,	--CONTRA ,
ORDEN_OT ,	RUTAC ,	CODREQ ,
CZONAL ,	CMDF_NODO ,	--MOV_MAT
INS_CODCLI ,	TIPREQ ,	CODMOTV ,	NROPLANO ,	FECEJE ,	DESCRIPT ,	MOV ,	PLAYA ,	N_NEGOCIO ,	NEG_NUE ,	ACT_MAT ,	MOV_MAT ,	ACTIVIDAD ,
TELEFONO ,	PREFIJO ,	CODSER ,	CODMOV ,	TSPEEDYACT ,	MODALACT ,	IND_PAQ ,	CANT --,	COD_ACT
)
SELECT  (SELECT CECO FROM CUENTA WHERE NEGOCIO = 'SPEEDY' AND MOV = 'AVERIAS')
,	 (SELECT COD_CUENTA FROM CUENTA WHERE NEGOCIO = 'SPEEDY' AND MOV = 'AVERIAS')
,	 (SELECT AF FROM CUENTA WHERE NEGOCIO = 'SPEEDY' AND MOV = 'AVERIAS')
,	 (SELECT DESCTA FROM CUENTA WHERE NEGOCIO = 'SPEEDY' AND MOV = 'AVERIAS'),	 'BUCLE',	 'OPEX',	 'TDP',	 CONTRA_TEC
,	-- CONTRATA,
SUBSTRING(CODAVERIA,4,7),	 0,	 0,	 ZON,	 CO_MDF,	--'AVERIAS'
0,	 ' ',	 ' ',	 ' ',	 FE_LIQU,
DBO.TRIM(TI_LIQN)+DBO.TRIM(RE_TI_LIQN),	 'AVERIAS',	 0,	 'BASICA',	 'AVERIAS ADSL',	 'TB',	 'AVERIAS',	 'AVERIAS ADSL',
0,	 ' ',	 ' ',	 ' ',	 ' ',	 ' ',	 CODAVERIA,	 1--,	 DBO.TRIM(TIPOLINEA)
FROM REIT_ADSL

ALTER TABLE REIT_ADSL ALTER COLUMN CODAVERIA NVARCHAR(255)


GO
/*
BEGIN TRAN
UPDATE A
SET A.CECO = ' ',
	A.COD_CUENTA = ' ',
	A.AF = ' ',
	A.DESCTA = ' ',
	A.TIPO = 'BUCLE',
	A.DEFINICION = 'OPEX',
	A.SOCIEDAD = 'TDP',
	A.CCONTR = B.CONTRA_TEC,
	A.CONTRA = B.CONTRATA,
	A.ORDEN_OT = SUBSTRING(B.CODAVERIA,4,7),
	A.RUTAC = 0,
	A.CODREQ = 0,
	A.CZONAL = B.ZON,
	A.CMDF_NODO = B.CO_MDF,
	--A.MOV_MAT = 'AVERIAS',
	A.INS_CODCLI = 0,
	A.TIPREQ = ' ',
	A.CODMOTV = ' ',
	A.NROPLANO = ' ',
	A.FECEJE = B.FECHA_LIQU,
	A.DESCRIPT = DBO.TRIM(B.TI_LIQN)+DBO.TRIM(B.TI_LIQN_DE),
	A.MOV = 'AVERIAS',
	A.PLAYA = 0,
	A.N_NEGOCIO = 'BASICA',
	A.NEG_NUE = 'AVERIAS ADSL',
	A.ACT_MAT = 'TB',
	A.MOV_MAT = 'AVERIAS',
	A.ACTIVIDAD = 'AVERIAS ADSL',
	A.TELEFONO = 0,
	A.PREFIJO = ' ',
	A.CODSER = ' ',
	A.CODMOV = ' ',
	A.TSPEEDYACT = ' ',
	A.MODALACT = ' ',
	A.IND_PAQ = B.CODAVERIA,
	A.CANT = 1,
	A.COD_ACT = DBO.TRIM(B.TIPOLINEA)
FROM data1908 A JOIN ADSL_FINAL B ON 1 = 1

*/
--CREATE PROCEDURE CARGA_AV_STB
--AS

 ALTER TABLE REIT_STB ADD CONTRATA NVARCHAR(255)
 ALTER TABLE REIT_STB ADD CONTRA_TEC NVARCHAR(255)

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

--****************************************************************************************************
--****************************************************************************************************

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

/*
if seek('72310-0')
	       replace arch.cod_uni with uni.cod_uni
           replace arch.desc_uni with  uni.desc_uni
	       replace arch.bar_uni  with  uni.bar_uni
	       replace arch.bar_tot  with  uni.bar_uni
        endif

	    select pre
	         wcon=alltrim(arch.contra)+alltrim(arch.zonal)
	         if seek(wcon)
	            replace arch.precio with pre.precio
	            replace arch.monto  with arch.bar_tot*arch.precio*-.75
	            replace arch.OPEX  with arch.bar_tot*arch.precio*-.75
	         ELSE
	            replace arch.precio with 0
	         endif

	    select jefa
	        if seek(arch.cmdf_nodo)
	           replace arch.czonal with jefa.czonal
	           replace arch.jefatura   with jefa.jef_cmr
               replace arch.zonal_bono with jefa.zonal_bono
	           replace arch.jefa_mat   with jefa.jefa_mat
	         endif
	    select cam
	endscan
	*/

ALTER TABLE REIT_STB ALTER COLUMN CODAVERIA NVARCHAR(255)

INSERT INTO data1908 (CECO ,	COD_CUENTA ,	AF ,	DESCTA ,	TIPO ,	DEFINICION ,	SOCIEDAD ,	CCONTR ,	CONTRA ,	ORDEN_OT ,	RUTAC ,	CODREQ ,
CZONAL ,	CMDF_NODO , --MOV_MAT
INS_CODCLI ,	TIPREQ ,	CODMOTV ,	NROPLANO ,	FECEJE ,	DESCRIPT ,	MOV ,	PLAYA ,	N_NEGOCIO ,	NEG_NUE ,	ACT_MAT ,	MOV_MAT ,	ACTIVIDAD ,
TELEFONO ,	PREFIJO ,	CODSER ,	CODMOV ,	TSPEEDYACT ,	MODALACT ,	IND_PAQ ,	CANT --,	COD_ACT
)
SELECT  (SELECT CECO FROM CUENTA WHERE NEGOCIO = 'SPEEDY' AND MOV = 'AVERIAS')
,	 (SELECT COD_CUENTA FROM CUENTA WHERE NEGOCIO = 'SPEEDY' AND MOV = 'AVERIAS')
,	 (SELECT AF FROM CUENTA WHERE NEGOCIO = 'SPEEDY' AND MOV = 'AVERIAS')
,	 (SELECT DESCTA FROM CUENTA WHERE NEGOCIO = 'SPEEDY' AND MOV = 'AVERIAS'),	 'BUCLE',	 'OPEX',	 'TDP',	CONTRA_TEC
,	 CONTRATA,	 SUBSTRING(CODAVERIA,4,7),	 0,	 0,	 ZON,	 CO_MDF,	-- 'AVERIAS'
0,	 ' ',	 ' ',	 ' ',	 FE_LIQU,
DBO.TRIM(TI_LIQN)+DBO.TRIM(RE_TI_LIQN),	 'AVERIAS',	 0,	 'BASICA',	 'AVERIAS STB',	 'TB',	 'AVERIAS',	 'AVERIAS STB',	 0,
' ',	 ' ',	 ' ',	 ' ',	 ' ',	 CODAVERIA,	 1--,	 DBO.TRIM(TIPOLINEA)
FROM REIT_STB

GO


EXEC AVERIAS_CALCULO
