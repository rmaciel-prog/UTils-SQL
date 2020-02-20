/*    ==Parâmetros de Script==

    Edição do Mecanismo de Banco de Dados de Origem : Edição do Banco de Dados SQL do Microsoft Azure
    Tipo do Mecanismo de Banco de Dados de Origem : Banco de Dados SQL do Microsoft Azure

    Edição de Mecanismo de Banco de Dados de Destino : Edição do Banco de Dados SQL do Microsoft Azure
    Tipo de Mecanismo de Banco de Dados de Destino : Banco de Dados SQL do Microsoft Azure
*/

/****** Object:  UserDefinedFunction [dbo].[FUNC_TRATA_CONSOANTE_MUDA]    Script Date: 09/12/2019 11:29:06 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[FUNC_TRATA_CONSOANTE_MUDA] (@STR VARCHAR(5000), @CONSOANTE CHAR(1), @COMPLEMENTO CHAR(1))
RETURNS VARCHAR(5000)
AS
BEGIN
DECLARE
@I INT,
@CONTADOR INT

/*
PARA TODAS AS OCORRÊNCIAS DA CONSOANTE $consoante QUE NÃO ESTIVER SEGUIDA DE VOGAL, SERÁ ADICIONADO
O CONTEÚDO DA VARIÁVEL $complemento NA STRING.
*/

SET @I = LEN(@STR)
SET @CONTADOR = 1

LOOP:
BEGIN

-- for i in 1..length(tStr) loop
IF ((SUBSTRING(@STR,@CONTADOR,1) = @CONSOANTE) AND
(SUBSTRING(@STR,@CONTADOR + 1,1) NOT IN ('A','E','I','O','U')))

SET @STR = SUBSTRING(@STR,1,@CONTADOR) + @COMPLEMENTO + SUBSTRING(@STR,@CONTADOR + 1,LEN(@STR))

SET @CONTADOR = @CONTADOR + 1

IF @CONTADOR <= @I
GOTO LOOP

END

RETURN @STR

END
GO


