Error in loadNamespace(j <- i[[1L]], c(lib.loc, .libPaths()), versionCheck =
vI[[j]]) : namespace 'purrr' 0.3.4 is already loaded, but >= 1.0.1 is required
Traceback:
6: stop(gettextf("namespace %s %s is already loaded, but %s %s is required", 
       sQuote(package), current, zop, zversion), domain = NA)
5: loadNamespace(j <- i[[1L]], c(lib.loc, .libPaths()), versionCheck = vI[[j]])
4: asNamespace(ns)
3: namespaceImportFrom(ns, loadNamespace(j <- i[[1L]], c(lib.loc, 
       .libPaths()), versionCheck = vI[[j]]), i[[2L]], from = package)
2: loadNamespace(x)
1: google2rmd("https://docs.google.com/spreadsheets/d/1NCWf1bGPA5TzUtXjM4PmfT-lhJC2FF5cRHxtD5Rczk0/edit#gid=0", 
       "Example")

