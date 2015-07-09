local d = require "darkroom"
local Image = require "image"
local types = require "types"
local harness = require "harness"

W = 128
H = 64
T = 8

-------------
RAWTYPE = types.array2d( types.uint(8), T )
ITYPE = d.Stateful(RAWTYPE)
inp = d.input( ITYPE )
convLB = d.apply( "convLB", d.linebuffer( types.uint(8), W,H, T, -4 ), inp)
convpipe = d.apply( "slice", d.makeStateful(d.slice( types.array2d(types.uint(8),T,5), 0, T-1, 0, 0 ) ), convLB)
convpipe = d.lambda( "convpipe", inp, convpipe )
hsfn = d.makeHandshake(convpipe)

harness.axi("shifty_wide_handshake", hsfn, RAWTYPE, W,H, RAWTYPE,W,H)