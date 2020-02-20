/*    ==Par�metros de Script==

    Edi��o do Mecanismo de Banco de Dados de Origem : Edi��o do Banco de Dados SQL do Microsoft Azure
    Tipo do Mecanismo de Banco de Dados de Origem : Banco de Dados SQL do Microsoft Azure

    Edi��o de Mecanismo de Banco de Dados de Destino : Edi��o do Banco de Dados SQL do Microsoft Azure
    Tipo de Mecanismo de Banco de Dados de Destino : Banco de Dados SQL do Microsoft Azure
*/

/****** Object:  UserDefinedFunction [dbo].[Func_Fonetizar]    Script Date: 09/12/2019 11:25:56 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[Func_Fonetizar] (@STR VARCHAR(5000), @CONSULTA CHAR(1))
RETURNS VARCHAR(5000)
AS
BEGIN
DECLARE
  @PARTICULA        VARCHAR(5000),
  @FONETIZADO       VARCHAR(5000),
  @FONETIZAR        CHAR(1),
  @AUX              VARCHAR(5000),
  @I                INT,
  @CONT             INT,
  @PREPOSICOES1     VARCHAR(1000),
  @PREPOSICOES2     VARCHAR(1000),
  @ALGROMANO1       VARCHAR(1000),
  @NUMERO1          VARCHAR(1000),
  @ALGROMANO2       VARCHAR(1000),
  @NUMERO2          VARCHAR(1000),
  @ALGROMANO3       VARCHAR(1000),
  @NUMERO3          VARCHAR(1000),
  @ALGARISMO        VARCHAR(1000),
  @ALGARISMOEXTENSO VARCHAR(1000),
  @LETRAS           VARCHAR(1000)

  SELECT @STR = dbo.FUNC_REMOVE_ACENTO(@STR)

  /*********************************************/
  IF @STR = ' H '
     SET @STR = ' AGA '

  SELECT @STR = dbo.FUNC_SOMENTE_LETRAS(@STR)

  /*ELIMINAR PALAVRAS ESPECIAIS*/
  SELECT @STR = REPLACE(@STR,' LTDA ',' ')

  /*ELIMINAR PREPOSICOES*/
  SET @PREPOSICOES1 = ' DE  DA  DO  AS  OS  AO  NA  NO '
  SET @PREPOSICOES2 = ' DOS  DAS  AOS  NAS  NOS  COM '

  SET @I = 1

  WHILE @I <= 32
  BEGIN
     SELECT @STR = REPLACE(@STR,SUBSTRING(@PREPOSICOES1,@I,4),' ')
     SET @I = @I + 4
  END

  SET @I = 1

  WHILE @I <= 30
  BEGIN
     SELECT @STR = REPLACE(@STR,SUBSTRING(@PREPOSICOES2,@I,5),' ')
     SET @I = @I + 5
  END

  /*CONVERTE ALGARISMO ROMANO PARA NUMERO*/
  SET @ALGROMANO1 = ' V  I '
  SET @NUMERO1    = ' 5  1 '
  SET @I = 1
  WHILE @I <= 6
  BEGIN
     SELECT @STR = REPLACE(@STR,SUBSTRING(@ALGROMANO1,@I,3),SUBSTRING(@NUMERO1,@I,3))
     SET @I = @I + 3
  END

  SET @ALGROMANO2 = ' IX  VI  IV  II '
  SET @NUMERO2    = '  9   6   4   2 '
  SET @I = 1
  WHILE @I <= 16
  BEGIN
     SELECT @STR = REPLACE(@STR,SUBSTRING(@ALGROMANO2,@I,4),SUBSTRING(@NUMERO2,@I+1,3))
     SET @I = @I + 4
  END

  SET @ALGROMANO3 = ' VII  III '
  SET @NUMERO3    = '   7    3 '
  SET @I = 1
  WHILE @I <= 10
  BEGIN
     SELECT @STR = REPLACE(@STR,SUBSTRING(@ALGROMANO3,@I,5),SUBSTRING(@NUMERO3,@I+2,3))
     SET @I = @I + 5
  END

  SELECT @STR = REPLACE(@STR,' X ',' 10 ')
  SELECT @STR = REPLACE(@STR,' VIII ',' 8 ')


  /*CONVERTE NUMERO PARA LITERAL*/
  SELECT @STR = REPLACE(@STR,'0','ZERO')
  SELECT @STR = REPLACE(@STR,'1','UM')
  SELECT @STR = REPLACE(@STR,'2','DOIS')
  SELECT @STR = REPLACE(@STR,'3','TRES')
  SELECT @STR = REPLACE(@STR,'4','QUATRO')
  SELECT @STR = REPLACE(@STR,'5','CINCO')
  SELECT @STR = REPLACE(@STR,'6','SEIS')
  SELECT @STR = REPLACE(@STR,'7','SETE')
  SELECT @STR = REPLACE(@STR,'8','OITO')
  SELECT @STR = REPLACE(@STR,'9','NOVE')


  /*********************************************/
  /*ELIMINAR PREPOSICOES E ARTIGOS*/
  SET @LETRAS = ' A  B  C  D  E  F  G  H  I  J  K  L  M  N  O  P  Q  R  S  T  U  V  X  Z  W  Y ';

  SET @I = 1
  WHILE @I <= 78
  BEGIN
     SELECT @STR = REPLACE(@STR,SUBSTRING(@ALGROMANO2,@I,3),' ')
     SET @I = @I + 3
  END


  SET @STR = LTRIM(@STR)
  SET @STR = RTRIM(@STR)

  SET @PARTICULA  = ''
  SET @FONETIZADO = ''

  SET @CONT = 1

  WHILE @CONT <= LEN(@STR)+1
  BEGIN
     IF @CONT < LEN(@STR) + 1
     BEGIN
        IF SUBSTRING(@STR,@CONT,1) <> ' '
        BEGIN
           SET @PARTICULA = @PARTICULA + SUBSTRING(@STR,@CONT,1)
           SET @FONETIZAR = '0'
        END
        ELSE
           SET @FONETIZAR = '1'
     END
     ELSE
        SET @FONETIZAR = '1'
     IF @FONETIZAR = '1'
     BEGIN
        SELECT @PARTICULA = dbo.FUNC_FONETIZAR_PARTICULA(@PARTICULA)
        SET @FONETIZADO = @FONETIZADO + ' ' + @PARTICULA
        SET @PARTICULA = ''
     END
     SET @CONT = @CONT + 1
  END

  SET @FONETIZADO = LTRIM(@FONETIZADO)
  SET @FONETIZADO = RTRIM(@FONETIZADO)


  /*PREPARA A STRING PARA UM LIKE*/
  IF @CONSULTA = '1'
  BEGIN
    SET @AUX = '%'

    SET @I = 1

    WHILE @I <= LEN(@FONETIZADO)
    BEGIN
       IF SUBSTRING(@FONETIZADO,@I,1) = ' '
         SET @AUX = @AUX + '% %'
       ELSE
         SET @AUX = @AUX + SUBSTRING(@FONETIZADO,@I,1)
       SET @I = @I + 1
    END

    IF SUBSTRING(@FONETIZADO,LEN(@FONETIZADO),1) <> '%'
       SET @AUX = @AUX + '%'

    SET @FONETIZADO = @AUX
  END
  IF @FONETIZADO = ''
     SET @FONETIZADO = NULL
  
  RETURN @FONETIZADO
  
END
GO


