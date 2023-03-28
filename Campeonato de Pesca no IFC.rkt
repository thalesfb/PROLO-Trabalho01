#lang racket/base

;;==========================================================================
;;===                Code generated with MrEd Designer 3.17              ===
;;===              https://github.com/Metaxal/MrEd-Designer              ===
;;==========================================================================

;;; Call (campeonatoPescaIFC-init) with optional arguments to this module
(require db)
;(require mred-designer)
(define SQLite
        (sqlite3-connect #:database "G:/Meu Drive/Facul/Programação Lógica e Funcional/Trabalho01/db/pescaria.db"
                         #:mode 'create)
)
(require
 racket/gui/base
 racket/class
 racket/list
 )

(provide campeonatoPescaIFC-init
         frCampeonato
         txtNomeCampeonato
         btSalvarCampeonato
         frCompetidores)

(define (label-bitmap-proc l)
  (let ((label (first l)) (image? (second l)) (file (third l)))
    (or (and image?
             (or (and file
                      (let ((bmp (make-object bitmap% file 'unknown/mask)))
                        (and (send bmp ok?) bmp)))
                 "<Bad Image>"))
        label)))

(define (list->font l)
  (with-handlers
   ((exn:fail?
     (λ (e)
       (send/apply
        the-font-list
        find-or-create-font
        (cons (first l) (rest (rest l)))))))
   (send/apply the-font-list find-or-create-font l)))

(define campeonatoPescaIFC #f)
(define frCampeonato #f)
(define pCampeonatoTXT #f)
(define txtNomeCampeonato #f)
(define pCampeonatoBT #f)
(define btSalvarCampeonato #f)
(define frCompetidores #f)
(define pCompetidores #f)
(define (campeonatoPescaIFC-init
         #:frCampeonato-width
         (frCampeonato-width 400)
         #:frCampeonato-height
         (frCampeonato-height 200)
         #:frCampeonato-alignment
         (frCampeonato-alignment (list 'center 'bottom))
         #:frCampeonato-min-width
         (frCampeonato-min-width 400)
         #:frCampeonato-min-height
         (frCampeonato-min-height 200)
         #:pCampeonatoTXT-alignment
         (pCampeonatoTXT-alignment (list 'center 'bottom))
         #:txtNomeCampeonato-code-gen-class
         (txtNomeCampeonato-code-gen-class text-field%)
         #:txtNomeCampeonato-callback
         (txtNomeCampeonato-callback
          (lambda (text-field control-event) (void)))
         #:txtNomeCampeonato-style
         (txtNomeCampeonato-style
          ((λ (l) (list* (first l) (second l) (third l)))
           (list 'single 'vertical-label '())))
         #:txtNomeCampeonato-font
         (txtNomeCampeonato-font
          (list->font
           (list 12 "Century Gothic" 'default 'normal 'normal #f 'default #f)))
         #:txtNomeCampeonato-vert-margin
         (txtNomeCampeonato-vert-margin 2)
         #:txtNomeCampeonato-horiz-margin
         (txtNomeCampeonato-horiz-margin 2)
         #:txtNomeCampeonato-min-width
         (txtNomeCampeonato-min-width 400)
         #:pCampeonatoBT-alignment
         (pCampeonatoBT-alignment (list 'center 'center))
         #:btSalvarCampeonato-code-gen-class
         (btSalvarCampeonato-code-gen-class button%)
         #:btSalvarCampeonato-label
         (btSalvarCampeonato-label (label-bitmap-proc (list "Escolher" #f #f)))
         #:btSalvarCampeonato-callback
         (btSalvarCampeonato-callback (lambda (button control-event) (void)))
         #:btSalvarCampeonato-font
         (btSalvarCampeonato-font
          (list->font
           (list 12 "Century Gothic" 'default 'normal 'normal #f 'default #f)))
         #:btSalvarCampeonato-enabled
         (btSalvarCampeonato-enabled #t)
         #:frCompetidores-width
         (frCompetidores-width 800)
         #:frCompetidores-height
         (frCompetidores-height 400)
         #:frCompetidores-min-width
         (frCompetidores-min-width 800)
         #:frCompetidores-min-height
         (frCompetidores-min-height 400)
         #:pCompetidores-code-gen-class
         (pCompetidores-code-gen-class pane%)
         #:pCompetidores-min-width
         (pCompetidores-min-width 800)
         #:pCompetidores-min-height
         (pCompetidores-min-height 400))
  (set! frCampeonato
    (new
     frame%
     (parent campeonatoPescaIFC)
     (label "Campeonato")
     (width frCampeonato-width)
     (height frCampeonato-height)
     (x #f)
     (y #f)
     (style '())
     (enabled #t)
     (border 0)
     (spacing 0)
     (alignment frCampeonato-alignment)
     (min-width frCampeonato-min-width)
     (min-height frCampeonato-min-height)
     (stretchable-width #t)
     (stretchable-height #t)))
  (set! pCampeonatoTXT
    (new
     pane%
     (parent frCampeonato)
     (vert-margin 0)
     (horiz-margin 0)
     (border 0)
     (spacing 0)
     (alignment pCampeonatoTXT-alignment)
     (min-width 0)
     (min-height 0)
     (stretchable-width #t)
     (stretchable-height #t)))
  (set! txtNomeCampeonato
    (new
     txtNomeCampeonato-code-gen-class
     (parent pCampeonatoTXT)
     (label "Nome do campeonato")
     (callback txtNomeCampeonato-callback)
     (init-value "")
     (style txtNomeCampeonato-style)
     (font txtNomeCampeonato-font)
     (enabled #t)
     (vert-margin txtNomeCampeonato-vert-margin)
     (horiz-margin txtNomeCampeonato-horiz-margin)
     (min-width txtNomeCampeonato-min-width)
     (min-height 0)
     (stretchable-width #f)
     (stretchable-height #f)))
  (set! pCampeonatoBT
    (new
     pane%
     (parent frCampeonato)
     (vert-margin 0)
     (horiz-margin 0)
     (border 0)
     (spacing 0)
     (alignment pCampeonatoBT-alignment)
     (min-width 0)
     (min-height 0)
     (stretchable-width #t)
     (stretchable-height #t)))
  (set! btSalvarCampeonato
    (new
     btSalvarCampeonato-code-gen-class
     (parent pCampeonatoBT)
     (label btSalvarCampeonato-label)
     (callback btSalvarCampeonato-callback)
     (style '())
     (font btSalvarCampeonato-font)
     (enabled btSalvarCampeonato-enabled)
     (vert-margin 2)
     (horiz-margin 2)
     (min-width 0)
     (min-height 0)
     (stretchable-width #f)
     (stretchable-height #f)))
  (set! frCompetidores
    (new
     frame%
     (parent campeonatoPescaIFC)
     (label "Competidores")
     (width frCompetidores-width)
     (height frCompetidores-height)
     (x #f)
     (y #f)
     (style '())
     (enabled #t)
     (border 0)
     (spacing 0)
     (alignment (list 'center 'center))
     (min-width frCompetidores-min-width)
     (min-height frCompetidores-min-height)
     (stretchable-width #t)
     (stretchable-height #t)))
  (set! pCompetidores
    (new
     pCompetidores-code-gen-class
     (parent frCompetidores)
     (vert-margin 0)
     (horiz-margin 0)
     (border 0)
     (spacing 0)
     (alignment (list 'center 'center))
     (min-width pCompetidores-min-width)
     (min-height pCompetidores-min-height)
     (stretchable-width #t)
     (stretchable-height #t)))
  (send frCampeonato show #t)
  (send frCompetidores show #f))

(module+ main (campeonatoPescaIFC-init))
