local R = require "rigelSimple"
local types = require "types"


--local Type = {types.bool(), types.uint(7), types.int(16)}
--local Type = {types.bool(), types.uint(8), types.uint(7)}
local Type = {types.uint(8)}
local NumP = {1,2,8}
local NumPZ = {0,3,8}
local Num = {-8,-3,0,2,7}
local LRBT = { {0,0,0,0}, {8,3,1,4}, {0,7,34,1} }
local IS = {64,32}

local configs = {}
local meta = {}

configs.padSeq=cartesian{type=Type, size={IS}, V=NumP, pad=LRBT, value={0,18}}
meta.padSeq={}
for k,v in ipairs(configs.padSeq) do
  if v.type==types.bool() then v.value=true end
  v.pad = shallowCopy(v.pad)
  for i=1,4 do if v.pad[i]%v.V~=0 then  v.pad[i]=upToNearest(v.V,v.pad[i]) end end

  meta.padSeq[k]={inputP=v.V, outputP=v.V, inputImageSize=v.size}
  meta.padSeq[k].outputImageSize={v.size[1]+v.pad[1]+v.pad[2], v.size[2]+v.pad[3]+v.pad[4]}

end

local cropAmt = { {1,1,1,1}, {0,2,0,2}, {2,0,0,2}, {0,0,0,0} }
configs.cropSeq=cartesian{type=Type, size={IS}, V=NumP, crop=cropAmt }
meta.cropSeq={}
for k,v in ipairs(configs.cropSeq) do
  v.crop = shallowCopy(v.crop)
  for i=1,4 do if v.crop[i]%v.V~=0 then  v.crop[i]=upToNearest(v.V,v.crop[i]) end end
    
  meta.cropSeq[k] = { inputP=v.V, outputP=v.V, inputImageSize=v.size }
  meta.cropSeq[k].outputImageSize={v.size[1]-v.crop[1]-v.crop[2], v.size[2]-v.crop[3]-v.crop[4]}
  print("CCCCCS","V",v.V,v.crop[1],v.crop[2],v.crop[3],v.crop[4])
  print("CS",v.size[1],v.size[2],meta.cropSeq[k].outputImageSize[1],meta.cropSeq[k].outputImageSize[2],v.V)
end

configs.changeRate = cartesian{type=Type, H={1}, inW=NumP, outW=NumP}
meta.changeRate={}
for k,v in ipairs(configs.changeRate) do
  meta.changeRate[k] = {inputP=v.inW, outputP=v.outW, inputImageSize=IS, outputImageSize=IS}
end

local function configToName(t)
  local name = ""

  for k,v in pairs(t) do
    local key = tostring(k).."_"
    if type(k)=="number" then key="" end -- not interesting!

    if type(v)=="number" or type(v)=="boolean" or type(v)=="string" or types.isType(v) then
      name = name..key..tostring(v).."_"
    elseif type(v)=="table" then
      name = name..key..configToName(v).."_"
    else
      print("CONFIGTONAME",type(v))
      assert(false)
    end
  end

  return name
end

for k,v in pairs(configs) do
  print("DO configs of ",k)

  for configk,config in ipairs(v) do
    local name = k.."_"..configToName(config)
    print("DOCONFIG",name)

    local mod = R.HS(R.modules[k](config))
    local met = meta[k][configk]

    -- TODO: hack to get around axi burst nonsense
    local valid = true
    --if ((met.inputImageSize[1]*met.inputImageSize[2]*mod.inputType:verilogBits())/met.inputP)%(128*8)~=0 then valid=false end
    --if ((met.outputImageSize[1]*met.outputImageSize[2]*mod.outputType:verilogBits())/met.outputP)%(128*8)~=0 then valid=false end

    --    if (mod.inputType:verilogBits())/met.inputP~=8 or (mod.outputType:verilogBits())/met.outputP~=8 then valid=false end
    
    -- TODO: 
    --if mod.inputType:isArray() and mod.inputType:arrayOver():isBool() then valid=false end
    
    local targets = {"verilog"}
    if valid then 
      table.insert(targets,"terra") 
    else
      print("SKIPPING TERRA BUILD")
    end
    
    for _,bk in pairs(targets) do
      R.harness{ outFile=name, fn=mod, inFile="../examples/frame_64.raw", inSize=IS, outSize=met.outputImageSize, backend=bk }
    end

  end
end

file = io.open("out/moduleparams.compiles.txt", "w")
file:write("Hello World")
file:close()
