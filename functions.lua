---------------------------------------------------------
-- Teoria de conjuntos - Functiones
---------------------------------------------------------

-- Tabla donde se registraran todas las funciones de modulo
local functions = {}

-- Funcion para copiar tablas de forma recursiva
local deepCopy = require("deepcopy")

-- Sobrescribir el operador [] de las cadenas para poder manejarlas como arreglos de caracteres
getmetatable('').__index = function(str, position) 
    return string.sub(str, position, position)
end

-- Interpretar cadena de entrada
local function parseSet(set, position)
    if(not position) then
        -- Inicializar indice de arreglo si la funcion se ejecuto desde fuera
        position = 1

        -- Eliminar espacios de la cadena andes de analizarla
        local newSet = ""
        for i = 1, string.len(set), 1 do
            if(set[i] ~= " ") then
                newSet = newSet .. set[i]
            end
        end
        set = newSet
    end

    -- Si el caracter es una llave abriendo, es un conjunto
    if(set[position] == "{") then
        -- Aumentamos 1 a la posicion para posicionarnos en el elemento a analizar
        position = position + 1

        -- Arreglo de salida, donde iran todos los elementos del conjunto
        local output = {}

        -- Iteramos la cadena de entrada para obtener todos los elementos del conjunto
        while(position < string.len(set)) do
            -- Recursividad pura y dura
            local result, newPosition = parseSet(set, position)

            -- Si el resultado no es nulo, lo insertamos en la salida y actualizamos la posicion actual
            if(result) then
                table.insert(output, result)
            end
            position = newPosition

            -- Despues de cada elemento esperamos una coma o una llave que cierre el conjunto
            if(set[position] == ",") then
                position = position + 1

            elseif(set[position] == "}") then
                position = position + 1
                break;
            else
                print("Error al analizar la cadena. (1)")
                os.exit()
            end
        end

        -- Devolvemos la salida junto con la posicion en la que nos quedamos
        return output, position

    -- Si el caracter es un parentesis abriendo, es un punto
    elseif(set[position] == "(") then
        position = position + 1;

        -- Extraer los numeros
        local first, newPosition = parseSet(set, position)
        position = newPosition + 1;
        local second, newPosition = parseSet(set, position)
        position = newPosition + 1

        -- Armar el punto
        local point = "(" .. first .. "," .. second .. ")"

        -- Verificar que el punto coincida con el formato (numero, numero) o (variable, variable)
        if(string.match(point, "(%d,%d)") or string.match(point, "(%s,%s)")) then
            return point, position
        else
            print("Error al analizar la cadena. (2)")
            os.exit()
        end

    -- Si el caracter es un valor numerico, se trata de un numero
    elseif(tonumber(set[position])) then
        local num = ""
        while(tonumber(set[position])) do
            num = num .. set[position]
            position = position + 1
        end
        if(num == "") then
            print("Error al analizar la cadena. (3)")
            os.exit()
        end
        return num, position

    -- Oh no
    else
        print("Error al analizar la cadena. Algo salio muy mal.")
        os.exit()
    end
end

-- Convertimos nuestro conjunto en una cadena para poder imprimirla
local function stringifySet(set)
    local output = "{ "
    for i = 1, #set, 1 do
        if(type(set[i]) == "string") then
            output = output .. set[i]
        else 
            output = output .. stringifySet(set[i])
        end
        if(i ~= #set) then
            output = output .. ", "
        else
            output = output .. " "
        end
    end
    output = output .. "}"
    return output
end

-- Comprueba si el conjunto tiene subconjuntos
local function hasSubsets(set) 
    for i = 1, #set, 1 do
        if(type(set[i]) == "table") then
            return true
        end
    end
    return false
end

-- Compara dos conjuntos y verifica que sean iguales
local function equals(setA, setB)
    local A = deepCopy(setA)
    local B = deepCopy(setB)

    -- Los dos conjuntos no deben estar vacios para poder compararlos
    if(#A > 0 and #B > 0) then
        for i = 1, #A, 1 do
            for j = 1, #B, 1 do
                if(type(A[i]) == "table" and type(B[j]) == "table") then
                    if(not equals(A[i], B[j])) then
                        return false
                    end

                elseif(type(A[i]) == "string" and type(B[j]) == "string") then
                    if(A[i] ~= B[j]) then
                        return false
                    end

                else
                    return false
                end
            end
        end
        return true

    -- Si los dos estan vacios son iguales
    elseif(#A == 0 and #B == 0) then
        return true

    -- Si solo uno de los dos esta vacio entonces no son iguales
    else
        return false
    end
end

-- Verificar si un elemento existe en un conjunto dado
local function valueExists(setInput, value) 
    local set = deepCopy(setInput)
    for i = 1, #set, 1 do
        if(type(value) == "table" and type(set[i]) == "table") then
            if(equals(set[i], value)) then
                return true
            end

        elseif(type(value) == type(set[i])) then
            if(value == set[i]) then
                return true
            end
        end
    end
    return false
end

-- Obtener cardinalidad de un conjunto
local function calculatecardinality(set) 
    return #set
end

-- Calcular conjunto potencia. La recursividad es horrible, pero funciona.
local function calculatePowerSet(set, output, index, currentPermutation) 
    -- Inicializar variables
    if(not output and not index and not currentPermutation) then
        output = {}
        index = 0
        currentPermutation = {}
    end

    if(index == #set + 1) then
        return
    end

    table.insert(output, currentPermutation)

    for i = index + 1, #set, 1 do
        -- Insertar elemento para la permitacion actual
        table.insert(currentPermutation, set[i])

        -- Magia. Las tablas por defecto pasan por referencia, la permutacion actual debe pasar por valor.
        calculatePowerSet(set, output, i, deepCopy(currentPermutation)) 

        -- Eliminar el ultimo elemento para poder realizar la siguiente permutacion
        table.remove(currentPermutation, #currentPermutation)
    end

    return output
end

-- Calcular union entre dos conjuntos
local function calculateUnion(setA, setB) 
    local result = deepCopy(setA)
    for i = 1, #setB, 1 do
        -- Si el elemento de B no existe todavia en A, entonces lo agregamos al conjunto
        if(not valueExists(setA, setB[i])) then
            table.insert(result, setB[i])
        end
    end

    -- Ordenar tabla solo si no tenemos subconjuntos
    if(not hasSubsets(result)) then
        table.sort(result)
    end
    
    return result
end

-- Calcular inserseccion entre dos conjuntos
local function calculateIntersection(setA, setB) 
    local result = {}
    for i = 1, #setB, 1 do
        -- Si el elemento de B existe en A, entonces lo agregamos al conjunto
        if(valueExists(setA, setB[i])) then
            table.insert(result, setB[i])
        end
    end
    
    -- Ordenar tabla solo si no tenemos subconjuntos
    if(not hasSubsets(result)) then
        table.sort(result)
    end
    
    return result
end

-- Calcular diferencia entre dos conjuntos
local function calculateDiff(setA, setB) 
    local result = {}
    for i = 1, #setA, 1 do
        -- Si el elemento de A existe en B, entonces lo agregamos al conjunto
        if(valueExists(setB, setA[i])) then
            table.insert(result, setA[i])
        end
    end
    
    -- Ordenar tabla solo si no tenemos subconjuntos
    if(not hasSubsets(result)) then
        table.sort(result)
    end
    
    return result
end

local function calculateCartesianProduct(setA, setB)
    local result = {}
    for i = 1, #setA, 1 do
        for j = 1, #setB, 1 do
            local p1 = setA[i]
            local p2 = setB[j]

            -- Si los puntos son conjuntos, convertirlos a cadena para poder concatenarlos
            if(type(p1) =="table") then
                p1 = stringifySet(p1)
            end
            if(type(p2) =="table") then
                p2 = stringifySet(p2)
            end

            -- Generar e insertar el punto
            local point = "(" .. p1 .. "," .. p2 .. ")"
            table.insert(result, point)
        end
    end
    return result
end

-- Agregar funciones a la tabla del modulo
functions.parseSet = parseSet;
functions.stringifySet = stringifySet
functions.hasSubsets = hasSubsets
functions.equals = equals
functions.valueExists = valueExists
functions.calculatecardinality = calculatecardinality
functions.calculatePowerSet = calculatePowerSet
functions.calculateUnion = calculateUnion
functions.calculateIntersection = calculateIntersection
functions.calculateDiff = calculateDiff
functions.calculateCartesianProduct = calculateCartesianProduct

return functions
