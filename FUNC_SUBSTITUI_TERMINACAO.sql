/*    ==Par�metros de Script==

    Edi��o do Mecanismo de Banco de Dados de Origem : Edi��o do Banco de Dados SQL do Microsoft Azure
    Tipo do Mecanismo de Banco de Dados de Origem : Banco de Dados SQL do Microsoft Azure

    Edi��o de Mecanismo de Banco de Dados de Destino : Edi��o do Banco de Dados SQL do Microsoft Azure
    Tipo de Mecanismo de Banco de Dados de Destino : Banco de Dados SQL do Microsoft Azure
*/

/****** Object:  UserDefinedFunction [dbo].[FUNC_SUBSTITUI_TERMINACAO]    Script Date: 09/12/2019 11:28:37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[FUNC_SUBSTITUI_TERMINACAO] (@STR VARCHAR(5000))
RETURNS VARCHAR(5000)
AS
BEGIN
DECLARE
@TERMINACAO VARCHAR(1000),
@TERMINACAOSUB VARCHAR(1000),
@TAMANHOMINSTR VARCHAR(1000),
@I INT

/*
SUBSTITUI AS TERMINA��ES CONTIDAS NO VETOR $vTerminacao PELAS DO VETOR $vTerminacaoSub RESPEITANDO
O TAMANHO M�NIMO DA STRING CONTIDO NO VETOR $vTamanhoMinStr.
NO CASO DA STRING TERMINAR COM �N�, O LA�O CONTINUAR�, POIS PODER�O EXIXTIR NOVAS SUBSTITUI��ES COM
A TERMINA��O �M�.
*/
SELECT @STR = dbo.FUNC_REMOVE_ACENTO(@STR)

SET @TERMINACAO = 'N B D T W AM OM OIMUIMCAOAO OEMONSEIAX US TH'
SET @TERMINACAOSUB = 'M N N N N SSNN N N IA IS OS TI'
SET @TAMANHOMINSTR = '23333222232222223'
SET @I = 1

LOOP:
BEGIN

IF RTRIM(SUBSTRING(@STR,LEN(@STR) - LEN(SUBSTRING(@TERMINACAO,@I,3)) + 1,LEN(SUBSTRING(@TERMINACAO,@I,3)))) = RTRIM(SUBSTRING(@TERMINACAO,@I,3)) AND
(LEN(@STR) >= CONVERT(INT,SUBSTRING(@TAMANHOMINSTR,@I,3)))
BEGIN
SET @STR = SUBSTRING(@STR,1,LEN(@STR)-LEN(SUBSTRING(@TERMINACAO,@I,3))) + RTRIM(SUBSTRING(@TERMINACAOSUB,@I,3))
IF @I > 1
GOTO FIM
END

SET @I = @I + 3

IF @I < 52
GOTO LOOP

END

FIM:
BEGIN
RETURN @STR
END

END
GO


