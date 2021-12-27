SET TERM ^ ;

CREATE OR ALTER PACKAGE ARRAY
AS
begin
    function Reset(Get_I Float, Get_J Float) returns VARCHAR(5000);
    function SetUp(Arr VARCHAR(5000), Get_I Float, Get_J Float, SetValue VARCHAR(50)) returns VARCHAR(5000);
    function GetIt(Arr VARCHAR(5000), Get_I Float, Get_J Float) returns VARCHAR(5000);
    function SetUpOld(Arr VARCHAR(5000), Get_I Float, Get_J Float, SetValue VARCHAR(50)) returns VARCHAR(5000);
    function ViewCurArr(Arr VARCHAR(5000)) returns VARCHAR(5000);
end^

SET TERM ; ^

commit work;

SET TERM ^ ;

RECREATE PACKAGE BODY ARRAY
AS
begin
--------  <BODY>  --------------------------------------------------------------

/*******************************************************************/
--"Reset" - Устанавливает диапазон массива [i,j]                   *
----Возвращает Массив VCBL                                         *
--"SetUp" - Записывае значение в указанную ячейку [i,j]            *
----Возвращает Массив VCBL                                         *
--"GetIt" - Отправляет значение ячейки по полученому ключу [i,j]   *
----Возвращает Значение Float                                      *
----ViewCurArr - принимает массив и Возвращает обработаный масив   *
--               грубо говоря красивый вид                         *
/*******************************************************************/

function Reset(
    GET_I Float,
    GET_J Float)
returns VARCHAR(5000)
as
declare variable i INTEGER;
declare variable j INTEGER;
declare variable TempArr VARCHAR(5000);
BEGIN
    --========== ОБнуление ============================    
    :GET_I = coalesce(:GET_I,1);
    :GET_J = coalesce(:GET_J,1);
    :i = 1;
    :j = 1;
    :TempArr = '|';
    --=================================================
    
    --Создания массива[] нулей
    -- i
    while(:i <= GET_I) do
    begin
        -- j
        while(:j <= GET_J) do
        begin
            if(:i = GET_I and :j = GET_J) then :TempArr = :TempArr||'0';
            else TempArr = TempArr||'0|';
            :j = :j + 1;
        end--for j
    
        if(:i <> GET_I) then
        begin
            :TempArr = :TempArr||'*';
        end
        :i = :i + 1;
        :j = 1;
    end-- for i
    --Возращаю массив

    return TempArr;
END--reset


function SetUp(
    ARR VARCHAR(5000),
    GET_I float,
    GET_J float,
    SETVALUE VARCHAR(50))
returns VARCHAR(5000)
AS
declare variable TempArr VARCHAR(5000);
declare variable search VARCHAR(10);
declare variable i INTEGER;
declare variable OneWay INTEGER;
declare variable j INTEGER;
declare variable Counter INTEGER;
declare variable PrefCount INTEGER;
declare variable thisCell INTEGER;
declare variable PrefCell INTEGER;

BEGIN
     --=========== Обновление ====================
    :TempArr = '';
    :i = 1;
    :j = 1;
    :OneWay = 0;
    :search = '0';
    :PrefCount = :counter+1;
    :Counter = Position('*', :arr);
    :Counter = 1;
    :thisCell = 1;
    --==========================================

    while (:search <> '1') do
    BEGIN
        --Поиск начальный порядковый номерсимвола i
        while(:i < Get_i) do
        begin
            :i = :i + 1;
            :PrefCount = :Counter;
            :Counter = Position('*', :arr, :Counter+1);
            :thisCell = :Counter+1;
            if(:i <= Get_i ) then
                :TempArr = :TempArr||substring(:arr FROM :PrefCount FOr :thisCell-:PrefCount-1);
        end
        if(:i <> 1 and :OneWay <> 1) then
        begin
            :TempArr = :TempArr||'*';
            :OneWay = 1;
        end

        :PrefCell = thisCell;
        :thisCell = Position('|', :arr, :PrefCell+1);
        if(:i = GET_I and :j = GET_J) then
        begin
            :TempArr = :TempArr||iif(:Get_j <> 1,'|','')||:SetValue||'|';
            if(thisCell <> 0) then
                :TempArr = :TempArr ||right(:arr, char_length(:arr)-thisCell);
            :search = '1';
        end
        else if(:i <> GET_I or :j <> GET_J) then
        begin
            :TempArr =  :TempArr || substring(:arr From :PrefCell FOR :thisCell-:PrefCell);
        end


         :j = :j + 1;

    END

    return :TempArr;
END -- SET


function GetIt(
Arr VARCHAR(5000),
    GET_I Float,
    GET_J Float)
returns VARCHAR(5000)
as
declare variable Temp_1 VARCHAR(5000);
declare variable Temp_Next VARCHAR(5000);
declare variable Cell VARCHAR(5000);
declare variable TempArr VARCHAR(5000);
declare variable i INTEGER;
declare variable j INTEGER;
declare variable search INTEGER;
declare variable Get_Tbl_j INTEGER;
declare variable Counter INTEGER;
declare variable PrefCount INTEGER;
BEGIN

    --=========== Обнуление ====================
    :TempArr = '';
    :Temp_1 = '';
    :Temp_Next = '';
    :search = '0';
    :TempArr = '';
    :Cell = '';
    :i = 1;
    :j = 1;
    :PrefCount = 2;
    :Counter = Position('*', :arr);
    --==========================================
    while (search <> '1') do
    BEGIN
        if(:Get_I = 1) then
        Begin
            ------------------------------------------------
            :TEMP_1 = Right(LEFT(:arr,:PrefCount),1);
            :TEMP_NEXT = Right(LEFT(:arr,:PrefCount+1),1);

            if(:TEMP_1 = '|' and :TEMP_NEXT <> '*') then
            begin
                :j = :j + 1;
            end
            if(:i = GET_I and :j = GET_J) then
            begin
                :Cell = :Cell || :TEMP_1;
            end

            if(:TEMP_1 = '*' or PrefCount = char_length(:arr) ) then
            begin
                :search = '1';
            end

            :PrefCount = :PrefCount + 1;
           --------------------------------------------------
        End
        else
        Begin
            if(:i <> Get_i) then
            begin
                :i = :i + 1;
                :PrefCount = :Counter+1;
                :Counter = Position('*', :arr, :Counter+1);
                --:Counter = :Counter + 1;
            end
            else
            begin
                ------------------------------------------------
                :TEMP_1 = Right(LEFT(:arr,:PrefCount),1);
                :TEMP_NEXT = Right(LEFT(:arr,:PrefCount+1),1);

                if(:i = GET_I and :j = GET_J) then
                begin
                    :Cell = :Cell || :TEMP_1;
                end

                if(:TEMP_1 = '|' and :TEMP_NEXT <> '*') then
                begin
                    :j = :j + 1;
                end

                if(:TEMP_1 = '*' or PrefCount = char_length(:arr) ) then
                begin
                    :search = '1';
                end
    
                :PrefCount = :PrefCount + 1;
               --------------------------------------------------
            end
        End

    END



    :Cell = replace(replace(replace(:Cell,ascii_char(10),''),'*',''),'|','');
    return :Cell;
END


function SetUpOld(
    Arr VARCHAR(5000),
    GET_I Float,
    GET_J Float,
    SetValue VARCHAR(50))
returns VARCHAR(5000)
as
declare variable Temp_1 VARCHAR(5000);
declare variable Temp_Next VARCHAR(5000);
declare variable Temp_Pref VARCHAR(5000);
declare variable Cell VARCHAR(5000);
declare variable TempArr VARCHAR(5000);
declare variable i INTEGER;
declare variable j INTEGER;
declare variable Counter INTEGER;
declare variable PrefCount INTEGER;
BEGIN
     --=========== ОБнуление ====================
    :TempArr = '';
    :i = 1;
    :j = 1;

    --:PrefCount = :counter+1;
    --:Counter = Position('*', :arr);

    :Counter = 1;


    --==========================================
    while(:Counter <= char_length(:arr) ) do
    begin
        :TEMP_1 = Right(LEFT(:arr,:Counter),1);
        :TEMP_NEXT = Right(LEFT(:arr,:Counter+1),1);

        if(:TEMP_1 = '|' and :TEMP_NEXT <> '*') then
        begin
            :j = :j + 1;
        end
        if(:TEMP_1 = '*' ) then
        begin
            :i = :i + 1;
            :j = 1;
            :Counter = :Counter + 1;
            :TempArr = :TempArr||'*';
        end
        --Перезапись массива с изменёным значение
        if(:i <> GET_I or :j <> GET_J) then
            :TempArr = :TempArr||Right(LEFT(:arr,:Counter),1);

        if(:i = GET_I and :j = GET_J) then
        begin
            :TempArr = :TempArr ||'|'|| :SetValue;
            :Counter = :Counter + 1;
            :j = :j + 1;
        end

        :Counter = :Counter + 1;
    end--for
    return :TempArr;
END -- Set



function ViewCurArr(
    Arr VARCHAR(5000) )
returns VARCHAR(5000)
AS
declare variable TempArr VARCHAR(5000);
declare variable search VARCHAR(10);
declare variable i INTEGER;
declare variable OneWay INTEGER;
declare variable j INTEGER;
declare variable Counter INTEGER;
declare variable PrefCount INTEGER;
declare variable thisCell INTEGER;
declare variable PrefCell INTEGER;
begin
    :TempArr = '';
    :search = '0';
    :PrefCount = 1;
    :Counter = 0;

    while (:search <> '1') do
    BEGIN
        --Поиск начальный порядковый номерсимвола i
        :PrefCount = :Counter+1;
        :Counter = Position('*', :arr, :Counter+1);
        :thisCell = :Counter+1;
        if(Counter = 0) then
        begin
            :search = '1';
        end
        else
        begin
            :TempArr = :TempArr||substring(:arr FROM :PrefCount FOr :thisCell-:PrefCount-1);
            :TempArr = :TempArr||ascii_char(13);
        end

     end
    return :TempArr;
END --ViewCurrArray

---  </BODY> ----------------------------------------------------------------------------
end^

SET TERM ; ^

commit work;
