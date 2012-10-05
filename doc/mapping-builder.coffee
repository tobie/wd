fs = require "fs"
mu = require 'mu2'

mu.root = __dirname

jsonWireFull = JSON.parse fs.readFileSync('doc/jsonwire-full.json').toString()
webdriverDoc = JSON.parse fs.readFileSync('doc/webdriver-doc.json').toString()
resMapping = []
for jw_k, jw_v of jsonWireFull  
  current = 
    key: jw_k
    method: jw_k.split(' ')[0]
    path: jw_k.split(' ')[1]
    url: "http://code.google.com/p/selenium/wiki/JsonWireProtocol##{jw_k.replace(/\s/g, '_')}"
    desc: jw_v
    wd_doc: []
  resMapping.push current      
  for wd_v in webdriverDoc
    if (t for t in wd_v.tags when t.type is 'jsonWire' and t.string is jw_k).length > 0       
      current.wd_doc.push
        'desc': ({line: l} for l in (wd_v.description.full.split '\n') when l isnt '')
        params: (t.string for t in wd_v.tags when t.type is 'param')
  current.wd_doc0 = current.wd_doc if current.wd_doc.length is 0 
  current.wd_doc1 = current.wd_doc if current.wd_doc.length is 1 
  current.wd_docN = [{wd_doc:current.wd_doc}] if current.wd_doc.length > 1 
  
mu.compileAndRender( 'mapping-template.htm', {mapping: resMapping})
  .on 'data', (data) ->
    process.stdout.write data.toString()

#console.log JSON.stringify resMapping, null, "\t"  



###
fs = require "fs"
async = require "async"
fd = fs.openSync "jsonwire.txt", "r"



keys = {}
i = 0
key = null
fs.readFileSync('jsonwire.txt').toString().split('\n').forEach (line) ->
  if (i % 2) is 0
    key = line.trim()
  else keys[key] = line.trim()
  i = i + 1;
console.log keys
  
fs.writeFileSync("jsonwire-full.json", JSON.stringify( keys, null, '  '), 'utf8')