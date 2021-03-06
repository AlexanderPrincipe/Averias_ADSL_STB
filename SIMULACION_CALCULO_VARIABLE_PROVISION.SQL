
	DROP TABLE [PV_STC_Comisiones]..PROVISION_OCTUBRE_COMPLETO

	DECLARE @NPS_PROMOTOR_PROVISION FLOAT
	DECLARE @NPS_NEUTRO_PROVISION FLOAT
	DECLARE @NPS_DETRACTOR_PROVISION FLOAT
	DECLARE @FACT_PLAZO_LIM_INF FLOAT
	DECLARE @FACT_PLAZO_LIM_SUP FLOAT
	DECLARE @FACT_AGENDA_LIM_INF FLOAT
	DECLARE @FACT_AGENDA_LIM_SUP FLOAT
	DECLARE @CUMPL_PLAZO_LIM_INF FLOAT
	DECLARE @CUMPL_PLAZO_LIM_SUP FLOAT
	DECLARE @CUMPL_AGENDA_LIM_INF FLOAT
	DECLARE @CUMPL_AGENDA_LIM_SUP FLOAT
	DECLARE @PESO_TCFL FLOAT
	DECLARE @PESO_AGENDA FLOAT


	--DECLARO PESOS DE NPS PARA PROVISION

	SET @NPS_PROMOTOR_PROVISION = 1.3
	SET @NPS_NEUTRO_PROVISION  = 0.9
	SET @NPS_DETRACTOR_PROVISION = 0.45

	--Y=Y0+((X-Xo)/(X1-Xo))*(Y1-Yo)

	--DECLARO LIMITES DEL CUMPLIMIENTO DE  TCFL Y DE EFECTIVIDADES
	SET @CUMPL_PLAZO_LIM_INF = 0.81		--Xo
	SET @CUMPL_PLAZO_LIM_SUP = 1.06		--X1

	SET @FACT_PLAZO_LIM_INF = 0.75		--Yo
	SET @FACT_PLAZO_LIM_SUP = 1.2		--Y1


	--DECLARO LIMITES DEL CUMPLIMIENTO DE  AGENDA
	SET @CUMPL_AGENDA_LIM_INF = 0.81	--Xo
	SET @CUMPL_AGENDA_LIM_SUP = 1.06	--X1

	SET @FACT_AGENDA_LIM_INF = 0.75		--Yo
	SET @FACT_AGENDA_LIM_SUP = 1.2	    --Y1

	--DECLARO EL PESO DE CADA VARIABLE
	SET @PESO_TCFL = 0.5
	SET @PESO_AGENDA = 0.5

	SELECT
	A.*,
	CT.INFANCIA_CUARTIL,
	CT.CANCELADAS_CUARTIL,
	CTR.INFANCIA_RESULTADO,
	CTR.CANCELADAS_RESULTADO,
	CUMPL.AGENDA_OBJETIVO,
	CUMPL.PLAZO_OBJETIVO,
	CUMPL.AGENDA_RESULTADO,
	CUMPL.PLAZO72H_RESULTADO,
	NPS.PROMOTOR,
	NPS.NEUTRO,
	NPS.DETRACTOR,
	ROUND(((CTR.INFANCIA_RESULTADO-CT.INFANCIA_CUARTIL) + (CTR.CANCELADAS_RESULTADO-CT.CANCELADAS_CUARTIL)),2) AS 'EXCESO',
	(1-((CTR.INFANCIA_RESULTADO-CT.INFANCIA_CUARTIL) + (CTR.CANCELADAS_RESULTADO-CT.CANCELADAS_CUARTIL)))*A.BAR_BRUTOS AS 'EVENTOS_PRODUCTIVOS',
	ROUND((NPS.PROMOTOR*@NPS_PROMOTOR_PROVISION+NPS.NEUTRO*@NPS_NEUTRO_PROVISION+NPS.DETRACTOR*@NPS_DETRACTOR_PROVISION),2) AS 'FACTOR_NPS',
	CASE WHEN PLAZO_OBJETIVO = 0 THEN 0 ELSE (PLAZO72H_RESULTADO/PLAZO_OBJETIVO) END AS '%CUMPL_TCFL',
	CASE WHEN AGENDA_OBJETIVO = 0 THEN 0 ELSE (AGENDA_RESULTADO/AGENDA_OBJETIVO) END AS '%CUMPL_AGENDA',
	CASE
		WHEN CASE WHEN PLAZO_OBJETIVO = 0 THEN 0 ELSE (PLAZO72H_RESULTADO/PLAZO_OBJETIVO) END < @CUMPL_PLAZO_LIM_INF THEN 0
		WHEN CASE WHEN PLAZO_OBJETIVO = 0 THEN 0 ELSE (PLAZO72H_RESULTADO/PLAZO_OBJETIVO) END > @CUMPL_PLAZO_LIM_SUP THEN @FACT_PLAZO_LIM_SUP
		ELSE (@FACT_PLAZO_LIM_INF+((CASE WHEN PLAZO_OBJETIVO = 0 THEN 0 ELSE (PLAZO72H_RESULTADO/PLAZO_OBJETIVO) END-@CUMPL_PLAZO_LIM_INF)/(@CUMPL_PLAZO_LIM_SUP-@CUMPL_PLAZO_LIM_INF))*(@FACT_PLAZO_LIM_SUP-@FACT_PLAZO_LIM_INF))
	END	*@PESO_TCFL +
	CASE
		WHEN CASE WHEN AGENDA_OBJETIVO = 0 THEN 0 ELSE (AGENDA_RESULTADO/AGENDA_OBJETIVO) END < @CUMPL_AGENDA_LIM_INF THEN 0
		WHEN CASE WHEN AGENDA_OBJETIVO = 0 THEN 0 ELSE (AGENDA_RESULTADO/AGENDA_OBJETIVO) END > @CUMPL_AGENDA_LIM_SUP THEN @FACT_AGENDA_LIM_SUP
		ELSE (@FACT_AGENDA_LIM_INF+((CASE WHEN AGENDA_OBJETIVO = 0 THEN 0 ELSE (AGENDA_RESULTADO/AGENDA_OBJETIVO) END-@CUMPL_AGENDA_LIM_INF)/(@CUMPL_AGENDA_LIM_SUP-@CUMPL_AGENDA_LIM_INF))*(@FACT_AGENDA_LIM_SUP-@FACT_AGENDA_LIM_INF))
	END	*@PESO_AGENDA AS EFECTIVIDAD,
	PB.PRECIO
	INTO [PV_STC_Comisiones]..PROVISION_OCTUBRE_COMPLETO
	FROM
	[PV_STC_Comisiones]..PROVISION_OCTUBRE A
	LEFT JOIN
	[PV_STC_Comisiones]..PROVISION_CUARTIL CT
	ON
	CT.REGION=A.REGION
	LEFT JOIN
	[PV_STC_Comisiones]..PROVISION_RESULTADO CTR
	ON
	CTR.REGION=A.REGION AND
	CTR.EECC=A.EECC AND
	CTR.JEF_CMR=A.JEF_CMR
	LEFT JOIN [PV_STC_Comisiones]..PROVISION_OBJ_RESUL_CUMPL CUMPL
	ON
	CUMPL.REGION=A.REGION AND
	CUMPL.EECC=A.EECC AND
	CUMPL.JEF_CMR=A.JEF_CMR
	LEFT JOIN
	[PV_STC_Comisiones]..CALCULO_PROVISION_NPS NPS
	ON
	NPS.REGION=A.REGION AND
	NPS.EECC=A.EECC
	LEFT JOIN
	[PV_STC_Comisiones]..PRECIOS_NUEVO PB
	ON
	PB.CONTRA=A.EECC AND
	(CASE WHEN A.REGION='REGION LIMA' THEN 'LIM' ELSE 'PRO' END) = PB.ZONAL
	GO

	DECLARE @FACT_LIM_INF FLOAT
	DECLARE @FACT_LIM_SUP FLOAT

	--DEFINO LOS LÍMITES DE FACTURACIÓN DEL VARIABLE
	SET @FACT_LIM_INF = 0.85
	SET @FACT_LIM_SUP = 1.15

	UPDATE PROVISION_OCTUBRE_COMPLETO
	SET EFECTIVIDAD = 1
	WHERE EECC = 'LARI' AND JEF_CMR = 'PUCALLPA'


	UPDATE PROVISION_OCTUBRE_COMPLETO
	SET EFECTIVIDAD = 1
	WHERE EECC = 'COMFICA' AND JEF_CMR = 'LIMA'

	SELECT
	A.*,
	A.EVENTOS_PRODUCTIVOS*A.FACTOR_NPS/**FDS*/*A.EFECTIVIDAD*A.PRECIO AS 'FACTURA_SIMULADA',
	A.EVENTOS_PRODUCTIVOS*A.PRECIO AS 'PXQ',
	CASE
		WHEN (A.EVENTOS_PRODUCTIVOS*A.FACTOR_NPS/**FDS*/*A.EFECTIVIDAD*A.PRECIO)/(A.EVENTOS_PRODUCTIVOS*A.PRECIO ) < @FACT_LIM_INF THEN (A.EVENTOS_PRODUCTIVOS*A.PRECIO )*@FACT_LIM_INF
		WHEN (A.EVENTOS_PRODUCTIVOS*A.FACTOR_NPS/**FDS*/*A.EFECTIVIDAD*A.PRECIO)/(A.EVENTOS_PRODUCTIVOS*A.PRECIO ) > @FACT_LIM_SUP THEN (A.EVENTOS_PRODUCTIVOS*A.PRECIO )*@FACT_LIM_SUP
	ELSE ROUND(A.EVENTOS_PRODUCTIVOS*A.FACTOR_NPS/**FDS*/*A.EFECTIVIDAD*A.PRECIO,2) END AS 'FACTURACION_FINAL'
	FROM
	[PV_STC_Comisiones]..PROVISION_OCTUBRE_COMPLETO A
	WHERE
	A.EECC + JEF_CMR <> 'LARITRUJILLO' AND
	A.EECC + JEF_CMR <> 'LARIAREQUIPA' AND
	A.EECC + JEF_CMR <> 'DOMINIONAREQUIPA'

-------------------------------------------------------------------------------------------------------
	SELECT * FROM PROVISION_CUARTIL
	SELECT * FROM PROVISION_OCTUBRE WHERE EECC = 'LARI' AND JEF_CMR = 'PUCALLPA'
	SELECT * FROM PROVISION_OCTUBRE_COMPLETO WHERE EECC = 'LARI' AND JEF_CMR = 'PUCALLPA'


	UPDATE PROVISION_OCTUBRE_COMPLETO
	SET EFECTIVIDAD = 1
	WHERE EECC = 'LARI' AND JEF_CMR = 'PUCALLPA'

	UPDATE PROVISION_OCTUBRE_COMPLETO
	SET EFECTIVIDAD = 1
	WHERE EECC = 'COMFICA' AND JEF_CMR = 'LIMA'


	SELECT * FROM PROVISION_CUARTIL
	SELECT * FROM PROVISION_RESULTADO
	SELECT * FROM PROVISION_NPS
	SELECT * FROM PROVISION_OBJ_RESUL_CUMPL
