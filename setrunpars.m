function runpar = setrunpars()
allc = configs_d();

runpar.method  = allc.runpar.method;
runpar.scene = allc.runpar.scene;
runpar.precon = allc.runpar.precon;
runpar.savesimvar = allc.runpar.savesimvar;