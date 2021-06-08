---------------------------------------------------------
-- Teoria de conjuntos - Demostracion
---------------------------------------------------------

-- Incluimos el modulo que tiene todas las funciones para realizar las operaciones
local fns = require("functions")

local A, B

-- Si no recibe el argumento de demostracion, solicitar los conjuntos
if(arg[1] ~= "demo") then
    print("> Introduce el conjunto A: ")
    A = io.read()
    print("> Introduce el conjunto B: ")
    B = io.read()

-- Si el argumento es recibido, utilizar los conjuntos predefinidos
else
    A = "{ 4, 3, 2 }"
    B = "{ 1, 2, 3 }"
end

-- Analizar cadenas de entrada
local parsedA = fns.parseSet(A)
local parsedB = fns.parseSet(B)

print()
print("---------------------------")

-- Imprimir conjuntos
print("Conjuntos")
print("A: " .. fns.stringifySet(parsedA))
print("B: " .. fns.stringifySet(parsedB))
print("---------------------------")

-- Cardinalidad
print("Cardinalidad")
print("#A: " .. fns.calculatecardinality(parsedA))
print("#B: " .. fns.calculatecardinality(parsedB))
print("---------------------------")

-- Conjunto potencia
local powerSetA = fns.calculatePowerSet(parsedA)
local powerSetB = fns.calculatePowerSet(parsedB)
print("Conjuntos potencia")
print("P(A): " .. fns.stringifySet(powerSetA))
print("P(B): " .. fns.stringifySet(powerSetB))
print("---------------------------")

-- Cardinalidad del conjunto potencia
print("Cardinalidad del conjunto potencia")
print("#P(A): " .. fns.calculatecardinality(powerSetA))
print("#P(B): " .. fns.calculatecardinality(powerSetB))
print("---------------------------")

-- Union
local union = fns.calculateUnion(parsedA, parsedB)
print("Union")
print("AuB: " .. fns.stringifySet(union))
print("---------------------------")

-- Intersection
local intersection = fns.calculateIntersection(parsedA, parsedB)
print("Interseccion")
print("AnB: " .. fns.stringifySet(intersection))
print("---------------------------")

-- Difference
print("Diferencia")
print("A/B: " .. fns.stringifySet(fns.calculateDiff(parsedA, parsedB)))
print("---------------------------")

-- Producto cartesiano
print("Producto cartesiano")
print("AxB: " .. fns.stringifySet(fns.calculateCartesianProduct(parsedA, parsedB)))
print("---------------------------")

-- Extra
local powerSetsDifference = fns.calculateUnion(powerSetA, powerSetB)
print("Extras")
print("P(A) / P(B): " .. fns.stringifySet(powerSetsDifference))
print("#(P(A) / P(B)): " .. fns.calculatecardinality(powerSetsDifference))
print("(AnB)x(AuB): " .. fns.stringifySet(fns.calculateCartesianProduct(intersection, union)))
print("---------------------------")

print("")
