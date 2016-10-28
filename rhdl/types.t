
package.cpath = package.cpath .. ";/home/rdaly/terra/release/lib/?.so"
require 'terra'

local asdl = require("asdl")
local List = asdl.List
local C = asdl.NewContext()

C:Extern("boolFuncion", function(t) return false end)
C:Define [[

Type = UInt(number bits)
    | Int(number bits)
    | Bool
    | Float(number e, number m)
    | Tensor(Type type, number dims, number* sizes)
    | Tuple(Type* types)
    attribute bool const

module Math {
  Bop = Add | Sub | Mult
  Exp = Param(string var)
      | Apply(Bop op, Tuple args)
      | Const(number c) unique
}

module Rhdl {

  Fun = Lambda(string* args, Math.Exp body)
      | Map(Fun f) 
      | Reduce(Fun f)
 
  Exp = Apply(Fun fun,Exp* args)
      | Input(Type type)
      | Array(Exp* exps, Type type)
      | Tuple(Exp* exps)
}

]]





local mult = C.Math.Bop("mult")
local a = C.Rhdl.Lambda(List({"a","b"}), C.Math.Apply(mult,List({C.Math.Param("a"),C.Math.Param("b")})))
print(a)




