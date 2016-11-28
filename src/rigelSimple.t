local R = require "rigel"
local types = require("types")
local RM = require "modules"
local C = require "examplescommon"
local harness = require "harness"

local RS = {}

local ccnt = 0

RS.uint8 = types.uint(8)
RS.int8 = types.int(8)
RS.uint32 = types.uint(32)
RS.uint16 = types.uint(16)
RS.float = types.float(32)
--RS.uint8[1] = types.array2d(RS.uint8,1)
--RS.uint8[25] = types.array2d(RS.uint8,25)
RS.input = R.input

function RS.array(t,x,y) return types.array2d(t,x,y) end
RS.array2d = RS.array
RS.tuple = types.tuple

RS.modules = {}
function RS.modules.padSeq(t)
  return RM.liftHandshake(RM.padSeq( t.type, t.size[1], t.size[2], t.P, t.pad[1], t.pad[2], t.pad[3], t.pad[4], t.value ))
end

function RS.modules.cropSeq(t)
  return C.cropHelperSeq( t.type, t.size[1], t.size[2], t.P, t.crop[1], t.crop[2], t.crop[3], t.crop[4] )
--  return RM.cropSeq( t.type, t.size[1], t.size[2], t.P, t.crop[1], t.crop[2], t.crop[3], t.crop[4] )
end

function RS.modules.changeRate(t)
  return RM.changeRate( t.type, t.H, t.inputW, t.outputW )
end

function RS.modules.linebuffer(t)
  local A = C.stencilLinebuffer( t.type, t.size[1], t.size[2], t.P, t.stencil[1], t.stencil[2], t.stencil[3], t.stencil[4] )
  local B = C.unpackStencil( t.type, -t.stencil[1]+1, -t.stencil[3]+1, t.P )
  ccnt = ccnt + 1
  return RM.makeHandshake(C.compose("v"..ccnt,B,A))
end

function RS.modules.SoAtoAoS(t)
  if t.size[2]==nil then t.size[2]=1 end
  return RM.SoAtoAoS( t.size[1], t.size[2], t.type )
end

function RS.modules.reduce(t)
  return RM.reduce( t.fn, t.size[1], t.size[2] )
end

function RS.modules.reduceSeq(t)
  return RM.reduceSeq( t.fn, t.P )
end

function RS.modules.map(t)
  local X,Y
  if type(t.size)=="table" then X,Y = t.size[1],t.size[2] end
  if type(t.size)=="number" then X,Y = t.size,nil end

  return RM.map( t.fn, X,Y )
end

function RS.modules.sum(t)
  return C.sum(t.inType, t.inType, t.outType)
end

function RS.modules.sumAsync(t)
  return C.sum( t.inType, t.inType, t.outType, true )
end

function RS.modules.mult(t)
  return C.multiply(t.inType, t.inType, t.outType)
end

function RS.modules.shiftAndCast(t)
  return C.shiftAndCast(t.inType, t.outType, t.shift)
end

function RS.modules.constSeq(t)
  local size = t.type:arrayLength()
  return RM.constSeq(t.value, t.type:arrayOver(), size[1], size[2], t.P )
end

function RS.modules.filterSeq(t)
  return RM.filterSeq( t.type, t.size[1], t.size[2], 1/t.rate, t.fifoSize )
end

function RS.connect(t)

  local inp = t.input

  if t.input~=nil and t.input.kind=="apply" then
    if R.isHandshake(t.input.fn.outputType) and R.isHandshake(t.toModule.inputType) then
      local btype = R.extractData(t.input.fn.outputType)
      local itype = R.extractData(t.toModule.inputType)
      
      if btype==types.array2d(itype,1) then
        ccnt = ccnt + 1
        inp = R.apply( "v"..tostring(ccnt), RS.RV(C.index(btype,0)), inp )
      elseif types.array2d(btype,1)==itype then
        ccnt = ccnt + 1
        inp = R.apply( "v"..tostring(ccnt), RS.RV(C.arrayop(btype,1,1)), inp )
      end
    end
  end

  ccnt = ccnt + 1
  return R.apply( "v"..tostring(ccnt), t.toModule, inp )
end

function RS.constant(t)
  ccnt = ccnt + 1
  return R.constant( "v"..tostring(ccnt), t.value, t.type )
end

function RS.concat(t)
  ccnt = ccnt + 1
  return R.tuple( "v"..tostring(ccnt), t )
end

function lookupType(t)
  if t.kind=="apply" then
    return t.fn.outputType
  elseif t.kind=="selectStream" then
    return lookupType(t.inputs[1]):arrayOver()
  elseif t.kind=="applyMethod" then
    return t.inst.fn.outputType
  else
    assert(false)
  end

end

function RS.fifo(t)
  local ty = lookupType(t.input)
  assert( R.isHandshake(ty))
  ty = R.extractData(ty)

  t.fifoList.fifos = t.fifoList.fifos or {}
  t.fifoList.statements = t.fifoList.statements or {}

  ccnt = ccnt + 1
  return C.fifo( t.fifoList.fifos, t.fifoList.statements, ty, t.input, t.depth, "v"..tostring(ccnt), false )
end

function RS.index(t)
  if t.input.kind=="apply" or t.input.kind=="applyMethod" or t.input.kind=="selectStream" then
    local ty=lookupType(t.input)

    print("FANOUTTYPE",ty)
    assert( R.isHandshake(ty))
    ty = R.extractData(ty)
    ccnt = ccnt + 1
    return R.apply("v"..tostring(ccnt), RM.makeHandshake(C.index(ty,t.key)), t.input )
  else
    print(t.input.kind)
    assert(false)
  end

end


function RS.fanOut(t)
  if t.input.kind=="apply" or t.input.kind=="applyMethod" then
    local ty
    if t.input.kind=="apply" then
      ty = t.input.fn.outputType
    else
      ty = t.input.inst.fn.outputType
    end

    print("FANOUTTYPE",ty)
    assert( R.isHandshake(ty))
    ty = R.extractData(ty)
    ccnt = ccnt + 1
    local out = R.apply("v"..tostring(ccnt),RM.broadcastStream(ty,t.branches), t.input )
    
    local res = {}
    for i=1,t.branches do
      ccnt = ccnt + 1
      table.insert(res, R.selectStream("v"..tostring(ccnt), out, i-1) )
    end
    return unpack(res)
  else
    print(t.input.kind)
    assert(false)
  end
  
end

function RS.fanIn(t)
  local typelist = {}
  for _,v in ipairs(t) do
    local ty
    if v.kind=="apply" then
      ty = v.fn.outputType
    elseif v.kind=="applyMethod" then
      ty = v.inst.fn.outputType
    else
      print("KND",v.kind)
      assert(false)
    end

    assert( R.isHandshake(ty))
    ty = R.extractData(ty)

    table.insert(typelist,ty)
  end
  
  ccnt = ccnt + 1
  ccnt = ccnt + 1
  return R.apply("v"..tostring(ccnt-1), RM.packTuple(typelist), R.tuple("v"..tostring(ccnt),t,false) )
end

function RS.pipeline(t)
  ccnt = ccnt + 1
  local out = t.output
  local fifoList

  if t.fifoList~=nil then
    local stats = {t.output}
    for k,v in ipairs(t.fifoList.statements) do table.insert(stats,v) end
    out = R.statements(stats)
    fifoList = t.fifoList.fifos
  end

  return RM.lambda("v"..tostring(ccnt), t.input, out, fifoList )
end

function RS.RV(t) 
  if types.isType(t) then
    return R.Handshake(t) 
  elseif R.isFunction(t) then
    print("LIFT",t.name,t.kind,t.inputType,t.outputType)
    if R.isV(t.inputType) and R.isRV(t.outputType) then
      print("LIFTHANDSHAKE")
      return RM.liftHandshake(t)
    elseif R.isHandshake(t.inputType) then
      print("ISHANDSHAKE")
      return t
    elseif (R.isBasic(t.inputType) and R.isV(t.outputType)) or (t.outputType:isTuple() and t.outputType.list[2]:isBool()) then
      print("LIFTDECIM")
      return RM.liftHandshake(RM.liftDecimate(t))
    elseif R.isBasic(t.inputType) and R.isBasic(t.outputType) then
      print("MAKEHANDSHAKE")
      return RM.makeHandshake(t)
    else
      print(t.inputType)
      assert(false)
    end
  else
    assert(false)
  end
end

function RS.harness(t)
  -- just assume we were given a handshake vector...
  print("ITYPE",t.fn.inputType)
  R.expectHandshake(t.fn.inputType)
  local iover = R.extractData(t.fn.inputType)
  assert(iover:isArray())
  local inputP = iover:channels()

  print("OTYPE",t.fn.outputType)
  R.expectHandshake(t.fn.outputType)
  local oover = R.extractData(t.fn.outputType)
  assert(oover:isArray())
  local outputP = oover:channels()

  local fn = t.fn

  if t.fn.inputType:verilogBits()~=64 or t.fn.outputType:verilogBits()~=64 then
    local inputP_orig = inputP
    inputP = (64/t.fn.inputType:verilogBits())*inputP
    iover = RS.array( iover:arrayOver(), inputP )

    local inp = RS.input( RS.RV(iover) )
    local out

    if t.fn.inputType:verilogBits()~=64 then
      out = RS.connect{input=inp, toModule=RS.RV(RS.modules.changeRate{ type = iover:arrayOver(), H=1, inputW=inputP, outputW=inputP_orig })}
    end
    
    out = RS.connect{input=out, toModule=fn}

    local outputP_orig = outputP
    outputP = (64/t.fn.outputType:verilogBits())*outputP
    oover = RS.array( oover:arrayOver(), outputP )
    
    if t.fn.outputType:verilogBits()~=64 then
      out = RS.connect{input=out, toModule=RS.RV(RS.modules.changeRate{ type = oover:arrayOver(), H=1, inputW=outputP_orig, outputW=outputP})}
    end

    fn = RS.pipeline{input=inp,output=out}
  end

  harness.axi( t.outputFile, fn, t.inputFile, nil, nil, iover, inputP, t.inputSize[1], t.inputSize[2], oover, outputP, t.outputSize[1], t.outputSize[2] )
end

return RS