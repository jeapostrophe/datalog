(module reader syntax/module-reader
  #:language `(planet ,(this-package-version-symbol lang/module))
  #:read (lambda ([in (current-input-port)])
           (let ([ast (parse-program in)])
             (list `(#%module-begin ,@ast))))
  #:read-syntax (lambda ([source-name #f] [in (current-input-port)])
                  (let ([ast (parse-program in)])
                    (list `(#%module-begin ,@ast))))
  #:whole-body-readers? #t
  (require (planet cce/scheme:4:1/planet)
           "../parse.ss"))