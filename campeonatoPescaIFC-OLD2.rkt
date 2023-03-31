#lang racket/base

(require
  racket/gui/base
  racket/gui
  racket/class
  racket/list
  )
(require db)
(define conn (sqlite3-connect #:database "./db/pescaria.db"
                              #:mode 'create))
#|   (when (not (sql-null? conn))
    (printf "Connected to SQLite database!\n")
    (printf "Not Connected to SQLite database!\n")) |#

(define create-campeonato-table
  "CREATE TABLE IF NOT EXISTS campeonato (
     id_campeonato INTEGER PRIMARY KEY AUTOINCREMENT,
     nome TEXT NOT NULL UNIQUE,
     n_competidores INTEGER NOT NULL,
     precoKG REAL NOT NULL,
     id_ganhador INTEGER,
     FOREIGN KEY(id_ganhador) REFERENCES competidor(id_competidor)
   );")

(define create-competidor-table
  "CREATE TABLE IF NOT EXISTS competidor (
     id_competidor INTEGER PRIMARY KEY AUTOINCREMENT,
     id_campeonato INTEGER NOT NULL,
     nome TEXT NOT NULL UNIQUE,
     CPF INTEGER NOT NULL UNIQUE,
     ano_nasc INTEGER NOT NULL,
     cidade TEXT NOT NULL,
     FOREIGN KEY(id_campeonato) REFERENCES campeonato(id_campeonato)
   );")

(define create-partida-table
  "CREATE TABLE IF NOT EXISTS partida (
     id_partida INTEGER PRIMARY KEY AUTOINCREMENT,
     id_campeonato INTEGER NOT NULL,
     id_competidor1 INTEGER NOT NULL,
     id_competidor2 INTEGER NOT NULL,
     FOREIGN KEY(id_campeonato) REFERENCES campeonato(id_campeonato),
     FOREIGN KEY(id_competidor1) REFERENCES competidor(id_competidor),
     FOREIGN KEY(id_competidor2) REFERENCES competidor(id_competidor)
   );")

(query-exec conn create-campeonato-table)
(query-exec conn create-competidor-table)
(query-exec conn create-partida-table)

(define (consultarCampeonato conn nome)
  (define stmt
    (prepare conn "SELECT * FROM campeonato WHERE nome = ?"))
  (define result (query-rows conn stmt nome))

  (if (not (empty? result))
      (car result)
      #f))

(provide campeonatoPescaIFC-init
         dlogCampeonato
         txtNomeCampeonato
         txtNumeroCompetidores
         txtPrecoPeixe
         btSalvarCampeonato
         dlogCompetidores
         txtNomeCompetidor
         txtCPF
         txtCidade
         txtIdade
         gpboxListaCompetidores
         dlogPartidas
         dlogGanhador)

(define id_campeonato 0)

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
(define dlogCampeonato #f)
(define vpCampeonato #f)
(define txtNomeCampeonato #f)
(define hpCampeonato #f)
(define txtNumeroCompetidores #f)
(define txtPrecoPeixe #f)
(define btSalvarCampeonato #f)
(define dlogCompetidores #f)
(define gpboxCompetidores #f)
(define vpCompetidor #f)
(define txtNomeCompetidor #f)
(define hpCompetidores #f)
(define txtCPF #f)
(define txtCidade #f)
(define txtIdade #f)
(define hpCompetidoresBT #f)
(define btPartidas #f)
(define btAtualizar #f)
(define btExcluir #f)
(define btSalvarCompetidor #f)
(define gpboxListaCompetidores #f)
(define lboxCompetidores #f)
(define dlogPartidas #f)
(define vpPartidas #f)
(define lboxPartidas #f)
(define btVerGanhador #f)
(define dlogGanhador #f)
(define pGanhador #f)
(define msgGanhador #f)

#| (define (on-btSalvarCampeonato-click event)
  (define nome (send txtNomeCampeonato get-value))
  (define resultado (consultarCampeonato nome))
  (if resultado
      (begin
        (send txtNumeroCompetidores set-value (number->string (second resultado)))
        (send txtPrecoPeixe set-value (number->string (third resultado)))
        (set! id_campeonato (first resultado)))
      (begin
        (send txtNumeroCompetidores set-value "")
        (send txtPrecoPeixe set-value "")
        (set! id_campeonato #f)
        (send txtNumeroCompetidores enable)
        (send txtPrecoPeixe enable)))) |#


(define (campeonatoPescaIFC-init
         #:dlogCampeonato-width (dlogCampeonato-width 400)
         #:dlogCampeonato-height (dlogCampeonato-height 200)
         #:dlogCampeonato-min-width (dlogCampeonato-min-width 400)
         #:dlogCampeonato-min-height(dlogCampeonato-min-height 200)
         #:vpCampeonato-vert-margin(vpCampeonato-vert-margin 10)
         #:vpCampeonato-horiz-margin (vpCampeonato-horiz-margin 10)
         #:vpCampeonato-spacing (vpCampeonato-spacing 0)
         #:txtNomeCampeonato-code-gen-class (txtNomeCampeonato-code-gen-class text-field%)
         #:txtNomeCampeonato-callback (txtNomeCampeonato-callback (lambda (text-field control-event) (void)))
         #:txtNomeCampeonato-style (txtNomeCampeonato-style ((λ (l) (list* (first l) (second l) (third l))) (list 'single 'vertical-label '())))
         #:txtNomeCampeonato-font (txtNomeCampeonato-font (list->font (list 12 "Century Gothic" 'default 'normal 'normal #f 'default #f)))
         #:txtNomeCampeonato-vert-margin (txtNomeCampeonato-vert-margin 2)
         #:txtNomeCampeonato-horiz-margin (txtNomeCampeonato-horiz-margin 2)
         #:txtNomeCampeonato-min-width (txtNomeCampeonato-min-width 400)
         #:hpCampeonato-vert-margin (hpCampeonato-vert-margin 0)
         #:hpCampeonato-horiz-margin (hpCampeonato-horiz-margin 0)
         #:txtNumeroCompetidores-code-gen-class (txtNumeroCompetidores-code-gen-class text-field%)
         #:txtNumeroCompetidores-callback(txtNumeroCompetidores-callback (lambda (text-field control-event) (void)))
         #:txtNumeroCompetidores-style (txtNumeroCompetidores-style ((λ (l) (list* (first l) (second l) (third l)))(list 'single 'vertical-label '())))
         #:txtNumeroCompetidores-font (txtNumeroCompetidores-font (list->font (list 12 "Century Gothic" 'default 'normal 'normal #f 'default #f)))
         #:txtNumeroCompetidores-vert-margin (txtNumeroCompetidores-vert-margin 2)
         #:txtNumeroCompetidores-horiz-margin (txtNumeroCompetidores-horiz-margin 20)
         #:txtNumeroCompetidores-min-width (txtNumeroCompetidores-min-width 0)
         #:txtNumeroCompetidores-min-height (txtNumeroCompetidores-min-height 0)
         #:txtPrecoPeixe-code-gen-class (txtPrecoPeixe-code-gen-class text-field%)
         #:txtPrecoPeixe-callback (txtPrecoPeixe-callback (lambda (text-field control-event) (void)))
         #:txtPrecoPeixe-style (txtPrecoPeixe-style ((λ (l) (list* (first l) (second l) (third l))) (list 'single 'vertical-label '())))
         #:txtPrecoPeixe-font (txtPrecoPeixe-font (list->font (list 12 "Century Gothic" 'default 'normal 'normal #f 'default #f)))
         #:txtPrecoPeixe-vert-margin (txtPrecoPeixe-vert-margin 2)
         #:txtPrecoPeixe-horiz-margin (txtPrecoPeixe-horiz-margin 20)
         #:txtPrecoPeixe-min-width (txtPrecoPeixe-min-width 0)
         #:txtPrecoPeixe-min-height (txtPrecoPeixe-min-height 0)
         #:btSalvarCampeonato-code-gen-class (btSalvarCampeonato-code-gen-class button%)
         #:btSalvarCampeonato-label (btSalvarCampeonato-label (label-bitmap-proc (list "Escolher" #f #f)))

         #|          (define (on-btSalvarCampeonato-click event)
           (define nome (send txtNomeCampeonato get-value))
           (define resultado (consultarCampeonato nome))
           (if resultado
               (begin
                 (send txtNumeroCompetidores set-value (number->string (second resultado)))
                 (send txtPrecoPeixe set-value (number->string (third resultado)))
                 (set! id_campeonato (first resultado)))
               (begin
                 (send txtNumeroCompetidores set-value "")
                 (send txtPrecoPeixe set-value "")
                 (set! id_campeonato #f)
                 (send txtNumeroCompetidores enable)
                 (send txtPrecoPeixe enable)))) |#
         ;(btPartidas-callback (lambda (button control-event) (void)))
         ;#:btSalvarCampeonato-callback (btSalvarCampeonato-callback (lambda (button control-event)(
         #|            (define nome (send txtNomeCampeonato get-value))
           (define n_competidores (string->number (send txtNumeroCompetidores get-value)))
           (define precoKG (string->number (send txtPrecoPeixe get-value)))

           (when (and nome n_competidores precoKG)
             (query-exec
              conn
              "INSERT INTO campeonato (nome, n_competidores, precoKG) VALUES (?, ?, ?)"
              nome n_competidores precoKG)

             (send txtNomeCampeonato set-value "")
             (send txtNumeroCompetidores set-value "")
             (send txtPrecoPeixe set-value "")
             (message-box "Success" "." (send btSalvarCampeonato get-parent)))) |#
         ;(print "oi")
         #| (define nome (send txtNomeCampeonato get-value))
                                                                                                   (define resultado (consultarCampeonato nome))
                                                                                                   (if resultado
                                                                                                       (begin
                                                                                                         (send txtNumeroCompetidores set-value (number->string (second resultado)))
                                                                                                         (send txtPrecoPeixe set-value (number->string (third resultado)))
                                                                                                         (set! id_campeonato (first resultado)))
                                                                                                       (begin
                                                                                                         (send txtNumeroCompetidores set-value "")
                                                                                                         (send txtPrecoPeixe set-value "")
                                                                                                         (set! id_campeonato #f)
                                                                                                         (send txtNumeroCompetidores enable)
                                                                                                         (send txtPrecoPeixe enable))) |#
         ;)))
         #|          #:btSalvarCampeonato-callback
         (btSalvarCampeonato-callback
          (lambda (button control-event)
            (define nome (send txtNomeCampeonato get-value))
            (define resultado (consultarCampeonato conn nome))
            (if resultado
                (begin
                  (send txtNumeroCompetidores set-value (number->string (vector-ref resultado 2)))
                  (send txtPrecoPeixe set-value (number->string (vector-ref resultado 3))))
                ;mensagem que o campeonato foi achado
                ;fechar a janela e ir para competidores
                (set! id_campeonato (first resultado)
                (begin
                  ;(send txtNumeroCompetidores set-value "")
                  ;(send txtPrecoPeixe set-value "")
                  (set! id_campeonato #f)
                  ;mensagem que o campeonato não foi achado e que é preciso inserir o numero de competidores e o valor do kg do peixe
                  (send txtNumeroCompetidores enable)
                  (send txtPrecoPeixe enable))))) |#
         #:btSalvarCampeonato-callback
         (btSalvarCampeonato-callback
          (lambda (button control-event)
            (define nome (send txtNomeCampeonato get-value))
            (define resultado (consultarCampeonato conn nome))
            (if resultado
                (begin
                  (send txtNumeroCompetidores set-value (number->string (vector-ref resultado 2)))
                  (send txtPrecoPeixe set-value (number->string (vector-ref resultado 3)))
                  (message-box "O campeonato foi encontrado. Clique em OK para ir para os competidores.")
                  (send dlogCampeonato destroy)
                  (send dlogCompetidores show #t)
                  )
                (begin
                  (set! id_campeonato #f)
                  ;(message-box "O campeonato não foi encontrado. Insira o número de competidores e o valor do kg do peixe.")
                  (message-box "O campeonato não foi encontrado. Insira o número de competidores e o valor do kg do peixe.")
                  (send txtNumeroCompetidores enable)
                  (send txtPrecoPeixe enable)))))
         #:btSalvarCampeonato-font (btSalvarCampeonato-font (list->font (list 12 "Century Gothic" 'default 'normal 'normal #f 'default #f)))
         #:btSalvarCampeonato-enabled (btSalvarCampeonato-enabled #t)
         #:dlogCompetidores-width (dlogCompetidores-width 400)
         #:dlogCompetidores-height (dlogCompetidores-height 200)
         #:dlogCompetidores-min-width (dlogCompetidores-min-width 400)
         #:dlogCompetidores-min-height (dlogCompetidores-min-height 200)
         #:gpboxCompetidores-code-gen-class (gpboxCompetidores-code-gen-class group-box-panel%)
         #:gpboxCompetidores-label (gpboxCompetidores-label "Dados do competidor")
         #:gpboxCompetidores-style (gpboxCompetidores-style '())
         #:gpboxCompetidores-font (gpboxCompetidores-font (list->font (list 12 "Century Gothic" 'default 'normal 'normal #f 'default #f)))
         #:gpboxCompetidores-enabled (gpboxCompetidores-enabled #t)
         #:vpCompetidor-code-gen-class (vpCompetidor-code-gen-class vertical-panel%)
         #:vpCompetidor-style (vpCompetidor-style '())
         #:vpCompetidor-vert-margin (vpCompetidor-vert-margin 10)
         #:vpCompetidor-horiz-margin (vpCompetidor-horiz-margin 0)
         #:vpCompetidor-alignment (vpCompetidor-alignment (list 'left 'top))
         #:txtNomeCompetidor-callback (txtNomeCompetidor-callback (lambda (text-field control-event) (void)))
         #:txtNomeCompetidor-font (txtNomeCompetidor-font (list->font(list 12 "Century Gothic" 'default 'normal 'normal #f 'default #f)))
         #:txtNomeCompetidor-vert-margin (txtNomeCompetidor-vert-margin 5)
         #:txtNomeCompetidor-horiz-margin (txtNomeCompetidor-horiz-margin 5)
         #:txtNomeCompetidor-min-width (txtNomeCompetidor-min-width 600)
         #:hpCompetidores-vert-margin (hpCompetidores-vert-margin 5)
         #:hpCompetidores-horiz-margin (hpCompetidores-horiz-margin 5)
         #:txtCPF-label (txtCPF-label "CPF:")
         #:txtCPF-callback (txtCPF-callback (lambda (text-field control-event) (void)))
         #:txtCPF-font (txtCPF-font (list->font (list 12 "Century Gothic" 'default 'normal 'normal #f 'default #f)))
         #:txtCPF-min-width (txtCPF-min-width 200)
         #:txtCidade-label (txtCidade-label "Cidade:")
         #:txtCidade-callback (txtCidade-callback (lambda (text-field control-event) (void)))
         #:txtCidade-font (txtCidade-font (list->font (list 12 "Century Gothic" 'default 'normal 'normal #f 'default #f)))
         #:txtCidade-vert-margin (txtCidade-vert-margin 5)
         #:txtCidade-horiz-margin (txtCidade-horiz-margin 5)
         #:txtCidade-min-width (txtCidade-min-width 200)
         #:txtIdade-label (txtIdade-label "Idade:")
         #:txtIdade-callback (txtIdade-callback (lambda (text-field control-event) (void)))
         #:txtIdade-font (txtIdade-font (list->font (list 12 "Century Gothic" 'default 'normal 'normal #f 'default #f)))
         #:txtIdade-enabled (txtIdade-enabled #t)
         #:txtIdade-vert-margin (txtIdade-vert-margin 5)
         #:txtIdade-horiz-margin (txtIdade-horiz-margin 5)
         #:txtIdade-min-width (txtIdade-min-width 0)
         #:hpCompetidoresBT-vert-margin (hpCompetidoresBT-vert-margin 5)
         #:hpCompetidoresBT-horiz-margin (hpCompetidoresBT-horiz-margin 5)
         #:hpCompetidoresBT-stretchable-width (hpCompetidoresBT-stretchable-width #t)
         #:hpCompetidoresBT-stretchable-height (hpCompetidoresBT-stretchable-height #t)
         #:btPartidas-label (btPartidas-label (label-bitmap-proc (list "Partidas" #f #f)))
         #:btPartidas-callback (btPartidas-callback (lambda (button control-event) (void)))
         #:btPartidas-style (btPartidas-style '())
         #:btAtualizar-label (btAtualizar-label (label-bitmap-proc (list "Atualizar" #f #f)))
         #:btAtualizar-callback (btAtualizar-callback (lambda (button control-event) (void)))
         #:btAtualizar-style (btAtualizar-style '())
         #:btExcluir-label (btExcluir-label (label-bitmap-proc (list "Excluir" #f #f)))
         #:btExcluir-callback (btExcluir-callback (lambda (button control-event) (void)))
         #:btExcluir-style (btExcluir-style '())
         #:btSalvarCompetidor-label (btSalvarCompetidor-label (label-bitmap-proc (list "Salvar" #f #f)))
         #:btSalvarCompetidor-callback (btSalvarCompetidor-callback (lambda (button control-event) (void)))
         #:btSalvarCompetidor-style (btSalvarCompetidor-style '())
         #:gpboxListaCompetidores-code-gen-class (gpboxListaCompetidores-code-gen-class group-box-panel%)
         #:gpboxListaCompetidores-label (gpboxListaCompetidores-label "Lista de competidores cadastrados no campeonato")
         #:gpboxListaCompetidores-style (gpboxListaCompetidores-style '())
         #:gpboxListaCompetidores-font (gpboxListaCompetidores-font (list->font (list 12 "Century Gothic" 'default 'normal 'normal #f 'default #f)))
         #:gpboxListaCompetidores-enabled (gpboxListaCompetidores-enabled #t)
         #:lboxCompetidores-choices (lboxCompetidores-choices (list "test" "test2" "test3"))
         #:lboxCompetidores-callback (lboxCompetidores-callback (lambda (list-box control-event) (void)))
         #:lboxCompetidores-style (lboxCompetidores-style ((lambda (l) (list* (first l) (second l) (third l))) (list 'single 'vertical-label '())))
         #:lboxCompetidores-selection (lboxCompetidores-selection 0)
         #:lboxCompetidores-enabled (lboxCompetidores-enabled #t)
         #:lboxCompetidores-vert-margin (lboxCompetidores-vert-margin 5)
         #:lboxCompetidores-horiz-margin (lboxCompetidores-horiz-margin 5)
         #:lboxCompetidores-min-width (lboxCompetidores-min-width 800)
         #:lboxCompetidores-min-height (lboxCompetidores-min-height 200)
         #:dlogPartidas-width (dlogPartidas-width 400)
         #:dlogPartidas-height (dlogPartidas-height 200)
         #:dlogPartidas-min-width (dlogPartidas-min-width 400)
         #:dlogPartidas-min-height (dlogPartidas-min-height 200)
         #:lboxPartidas-choices (lboxPartidas-choices (list "test" "test2" "test3"))
         #:lboxPartidas-callback (lboxPartidas-callback (lambda (list-box control-event) (void)))
         #:lboxPartidas-style (lboxPartidas-style ((lambda (l) (list* (first l) (second l) (third l))) (list 'single 'vertical-label '())))
         #:lboxPartidas-selection (lboxPartidas-selection 0)
         #:lboxPartidas-enabled (lboxPartidas-enabled #t)
         #:lboxPartidas-vert-margin (lboxPartidas-vert-margin 5)
         #:lboxPartidas-horiz-margin (lboxPartidas-horiz-margin 5)
         #:lboxPartidas-min-width (lboxPartidas-min-width 800)
         #:lboxPartidas-min-height (lboxPartidas-min-height 200)
         #:btVerGanhador-label (btVerGanhador-label (label-bitmap-proc (list "Ver ganhador" #f #f)))
         #:btVerGanhador-callback (btVerGanhador-callback (lambda (button control-event) (void)))
         #:btVerGanhador-style (btVerGanhador-style '())
         #:btVerGanhador-horiz-margin (btVerGanhador-horiz-margin 2)
         #:dlogGanhador-width (dlogGanhador-width 400)
         #:dlogGanhador-height (dlogGanhador-height 200)
         #:msgGanhador-label (msgGanhador-label (label-bitmap-proc (list "Aqui o ganhador!" #f #f)))
         #:msgGanhador-font (msgGanhador-font (list->font (list 12 "Century Gothic" 'default 'normal 'normal #f 'default #f)))
         #:msgGanhador-enabled (msgGanhador-enabled #t))
  (set! dlogCampeonato
        (new
         dialog%
         (parent campeonatoPescaIFC)
         (label "Campeonato")
         (width dlogCampeonato-width)
         (height dlogCampeonato-height)
         (x #f)
         (y #f)
         (style '())
         (enabled #t)
         (border 0)
         (spacing 0)
         (alignment (list 'center 'top))
         (min-width dlogCampeonato-min-width)
         (min-height dlogCampeonato-min-height)
         (stretchable-width #t)
         (stretchable-height #t)))
  (set! vpCampeonato
        (new
         vertical-panel%
         (parent dlogCampeonato)
         (style '())
         (enabled #t)
         (vert-margin vpCampeonato-vert-margin)
         (horiz-margin vpCampeonato-horiz-margin)
         (border 0)
         (spacing vpCampeonato-spacing)
         (alignment (list 'center 'top))
         (min-width 0)
         (min-height 0)
         (stretchable-width #t)
         (stretchable-height #t)))
  (set! txtNomeCampeonato
        (new
         txtNomeCampeonato-code-gen-class
         (parent vpCampeonato)
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
  (set! hpCampeonato
        (new
         horizontal-panel%
         (parent vpCampeonato)
         (style '())
         (enabled #t)
         (vert-margin hpCampeonato-vert-margin)
         (horiz-margin hpCampeonato-horiz-margin)
         (border 0)
         (spacing 0)
         (alignment (list 'center 'center))
         (min-width 0)
         (min-height 0)
         (stretchable-width #t)
         (stretchable-height #t)))
  (set! txtNumeroCompetidores
        (new
         txtNumeroCompetidores-code-gen-class
         (parent hpCampeonato)
         (label "Número de competidores")
         (callback txtNumeroCompetidores-callback)
         (init-value "")
         (style txtNumeroCompetidores-style)
         (font txtNumeroCompetidores-font)
         (enabled #f)
         (vert-margin txtNumeroCompetidores-vert-margin)
         (horiz-margin txtNumeroCompetidores-horiz-margin)
         (min-width txtNumeroCompetidores-min-width)
         (min-height txtNumeroCompetidores-min-height)
         (stretchable-width #f)
         (stretchable-height #f)))
  (set! txtPrecoPeixe
        (new
         txtPrecoPeixe-code-gen-class
         (parent hpCampeonato)
         (label "Preço do KG")
         (callback txtPrecoPeixe-callback)
         (init-value "")
         (style txtPrecoPeixe-style)
         (font txtPrecoPeixe-font)
         (enabled #f)
         (vert-margin txtPrecoPeixe-vert-margin)
         (horiz-margin txtPrecoPeixe-horiz-margin)
         (min-width txtPrecoPeixe-min-width)
         (min-height txtPrecoPeixe-min-height)
         (stretchable-width #f)
         (stretchable-height #f)))
  (set! btSalvarCampeonato
        (new
         btSalvarCampeonato-code-gen-class
         (parent vpCampeonato)
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
  (set! dlogCompetidores
        (new
         dialog%
         (parent campeonatoPescaIFC)
         (label "Competidores")
         (width dlogCompetidores-width)
         (height dlogCompetidores-height)
         (x #f)
         (y #f)
         (style '())
         (enabled #t)
         (border 0)
         (spacing 0)
         (alignment (list 'center 'top))
         (min-width dlogCompetidores-min-width)
         (min-height dlogCompetidores-min-height)
         (stretchable-width #t)
         (stretchable-height #t)))
  (set! gpboxCompetidores
        (new
         gpboxCompetidores-code-gen-class
         (parent dlogCompetidores)
         (label gpboxCompetidores-label)
         (style gpboxCompetidores-style)
         (font gpboxCompetidores-font)
         (enabled gpboxCompetidores-enabled)
         (vert-margin 2)
         (horiz-margin 2)
         (border 0)
         (spacing 0)
         (alignment (list 'center 'top))
         (min-width 0)
         (min-height 0)
         (stretchable-width #f)
         (stretchable-height #f)))
  (set! vpCompetidor
        (new
         vpCompetidor-code-gen-class
         (parent gpboxCompetidores)
         (style vpCompetidor-style)
         (enabled #t)
         (vert-margin vpCompetidor-vert-margin)
         (horiz-margin vpCompetidor-horiz-margin)
         (border 0)
         (spacing 0)
         (alignment vpCompetidor-alignment)
         (min-width 0)
         (min-height 0)
         (stretchable-width #f)
         (stretchable-height #f)))
  (set! txtNomeCompetidor
        (new
         text-field%
         (parent vpCompetidor)
         (label "Nome:")
         (callback txtNomeCompetidor-callback)
         (init-value "")
         (style
          ((λ (l) (list* (first l) (second l) (third l)))
           (list 'single 'horizontal-label '())))
         (font txtNomeCompetidor-font)
         (enabled #t)
         (vert-margin txtNomeCompetidor-vert-margin)
         (horiz-margin txtNomeCompetidor-horiz-margin)
         (min-width txtNomeCompetidor-min-width)
         (min-height 0)
         (stretchable-width #f)
         (stretchable-height #f)))
  (set! hpCompetidores
        (new
         horizontal-panel%
         (parent vpCompetidor)
         (style '())
         (enabled #t)
         (vert-margin hpCompetidores-vert-margin)
         (horiz-margin hpCompetidores-horiz-margin)
         (border 0)
         (spacing 0)
         (alignment (list 'center 'center))
         (min-width 0)
         (min-height 0)
         (stretchable-width #f)
         (stretchable-height #f)))
  (set! txtCPF
        (new
         text-field%
         (parent hpCompetidores)
         (label txtCPF-label)
         (callback txtCPF-callback)
         (init-value "")
         (style
          ((λ (l) (list* (first l) (second l) (third l)))
           (list 'single 'horizontal-label '())))
         (font txtCPF-font)
         (enabled #t)
         (vert-margin 5)
         (horiz-margin 5)
         (min-width txtCPF-min-width)
         (min-height 0)
         (stretchable-width #f)
         (stretchable-height #f)))
  (set! txtCidade
        (new
         text-field%
         (parent hpCompetidores)
         (label txtCidade-label)
         (callback txtCidade-callback)
         (init-value "")
         (style
          ((λ (l) (list* (first l) (second l) (third l)))
           (list 'single 'horizontal-label '())))
         (font txtCidade-font)
         (enabled #t)
         (vert-margin txtCidade-vert-margin)
         (horiz-margin txtCidade-horiz-margin)
         (min-width txtCidade-min-width)
         (min-height 0)
         (stretchable-width #f)
         (stretchable-height #f)))
  (set! txtIdade
        (new
         text-field%
         (parent hpCompetidores)
         (label txtIdade-label)
         (callback txtIdade-callback)
         (init-value "")
         (style
          ((λ (l) (list* (first l) (second l) (third l)))
           (list 'single 'horizontal-label '())))
         (font txtIdade-font)
         (enabled txtIdade-enabled)
         (vert-margin txtIdade-vert-margin)
         (horiz-margin txtIdade-horiz-margin)
         (min-width txtIdade-min-width)
         (min-height 0)
         (stretchable-width #f)
         (stretchable-height #f)))
  (set! hpCompetidoresBT
        (new
         horizontal-panel%
         (parent vpCompetidor)
         (style '())
         (enabled #t)
         (vert-margin hpCompetidoresBT-vert-margin)
         (horiz-margin hpCompetidoresBT-horiz-margin)
         (border 0)
         (spacing 0)
         (alignment (list 'right 'bottom))
         (min-width 0)
         (min-height 0)
         (stretchable-width hpCompetidoresBT-stretchable-width)
         (stretchable-height hpCompetidoresBT-stretchable-height)))
  (set! btPartidas
        (new
         button%
         (parent hpCompetidoresBT)
         (label btPartidas-label)
         (callback btPartidas-callback)
         (style btPartidas-style)
         (font
          (list->font
           (list 12 "Century Gothic" 'default 'normal 'normal #f 'default #f)))
         (enabled #t)
         (vert-margin 2)
         (horiz-margin 2)
         (min-width 0)
         (min-height 0)
         (stretchable-width #f)
         (stretchable-height #f)))
  (set! btAtualizar
        (new
         button%
         (parent hpCompetidoresBT)
         (label btAtualizar-label)
         (callback btAtualizar-callback)
         (style btAtualizar-style)
         (font
          (list->font
           (list 12 "Century Gothic" 'default 'normal 'normal #f 'default #f)))
         (enabled #t)
         (vert-margin 2)
         (horiz-margin 2)
         (min-width 0)
         (min-height 0)
         (stretchable-width #f)
         (stretchable-height #f)))
  (set! btExcluir
        (new
         button%
         (parent hpCompetidoresBT)
         (label btExcluir-label)
         (callback btExcluir-callback)
         (style btExcluir-style)
         (font
          (list->font
           (list 12 "Century Gothic" 'default 'normal 'normal #f 'default #f)))
         (enabled #t)
         (vert-margin 2)
         (horiz-margin 2)
         (min-width 0)
         (min-height 0)
         (stretchable-width #f)
         (stretchable-height #f)))
  (set! btSalvarCompetidor
        (new
         button%
         (parent hpCompetidoresBT)
         (label btSalvarCompetidor-label)
         (callback btSalvarCompetidor-callback)
         (style btSalvarCompetidor-style)
         (font
          (list->font
           (list 12 "Century Gothic" 'default 'normal 'normal #f 'default #f)))
         (enabled #t)
         (vert-margin 2)
         (horiz-margin 2)
         (min-width 0)
         (min-height 0)
         (stretchable-width #f)
         (stretchable-height #f)))
  (set! gpboxListaCompetidores
        (new
         gpboxListaCompetidores-code-gen-class
         (parent dlogCompetidores)
         (label gpboxListaCompetidores-label)
         (style gpboxListaCompetidores-style)
         (font gpboxListaCompetidores-font)
         (enabled gpboxListaCompetidores-enabled)
         (vert-margin 2)
         (horiz-margin 2)
         (border 0)
         (spacing 0)
         (alignment (list 'center 'top))
         (min-width 0)
         (min-height 0)
         (stretchable-width #f)
         (stretchable-height #f)))
  (set! lboxCompetidores
        (new
         list-box%
         (parent gpboxListaCompetidores)
         (label #f)
         (choices lboxCompetidores-choices)
         (callback lboxCompetidores-callback)
         (style lboxCompetidores-style)
         (font
          (list->font
           (list 12 "Century Gothic" 'default 'normal 'normal #f 'default #f)))
         (selection lboxCompetidores-selection)
         (enabled lboxCompetidores-enabled)
         (vert-margin lboxCompetidores-vert-margin)
         (horiz-margin lboxCompetidores-horiz-margin)
         (min-width lboxCompetidores-min-width)
         (min-height lboxCompetidores-min-height)
         (stretchable-width #f)
         (stretchable-height #f)
         (columns (list "Column"))
         (column-order #f)))
  (set! dlogPartidas
        (new
         dialog%
         (parent campeonatoPescaIFC)
         (label "Partidas")
         (width dlogPartidas-width)
         (height dlogPartidas-height)
         (x #f)
         (y #f)
         (style '())
         (enabled #t)
         (border 0)
         (spacing 0)
         (alignment (list 'center 'top))
         (min-width dlogPartidas-min-width)
         (min-height dlogPartidas-min-height)
         (stretchable-width #t)
         (stretchable-height #t)))
  (set! vpPartidas
        (new
         vertical-panel%
         (parent dlogPartidas)
         (style '())
         (enabled #t)
         (vert-margin 0)
         (horiz-margin 0)
         (border 0)
         (spacing 0)
         (alignment (list 'center 'center))
         (min-width 0)
         (min-height 0)
         (stretchable-width #f)
         (stretchable-height #f)))
  (set! lboxPartidas
        (new
         list-box%
         (parent vpPartidas)
         (label #f)
         (choices lboxPartidas-choices)
         (callback lboxPartidas-callback)
         (style lboxPartidas-style)
         (font
          (list->font
           (list 12 "Century Gothic" 'default 'normal 'normal #f 'default #f)))
         (selection lboxPartidas-selection)
         (enabled lboxPartidas-enabled)
         (vert-margin lboxPartidas-vert-margin)
         (horiz-margin lboxPartidas-horiz-margin)
         (min-width lboxPartidas-min-width)
         (min-height lboxPartidas-min-height)
         (stretchable-width #f)
         (stretchable-height #f)
         (columns (list "Column"))
         (column-order #f)))
  (set! btVerGanhador
        (new
         button%
         (parent vpPartidas)
         (label btVerGanhador-label)
         (callback btVerGanhador-callback)
         (style btVerGanhador-style)
         (font
          (list->font
           (list 12 "Century Gothic" 'default 'normal 'normal #f 'default #f)))
         (enabled #t)
         (vert-margin 2)
         (horiz-margin btVerGanhador-horiz-margin)
         (min-width 0)
         (min-height 0)
         (stretchable-width #f)
         (stretchable-height #f)))
  (set! dlogGanhador
        (new
         dialog%
         (parent campeonatoPescaIFC)
         (label "Parabéns ao ganhador!")
         (width dlogGanhador-width)
         (height dlogGanhador-height)
         (x #f)
         (y #f)
         (style '())
         (enabled #t)
         (border 0)
         (spacing 0)
         (alignment (list 'center 'top))
         (min-width 70)
         (min-height 30)
         (stretchable-width #t)
         (stretchable-height #t)))
  (set! pGanhador
        (new
         pane%
         (parent dlogGanhador)
         (vert-margin 0)
         (horiz-margin 0)
         (border 0)
         (spacing 0)
         (alignment (list 'center 'center))
         (min-width 0)
         (min-height 0)
         (stretchable-width #t)
         (stretchable-height #t)))
  (set! msgGanhador
        (new
         message%
         (parent pGanhador)
         (label msgGanhador-label)
         (style '())
         (font msgGanhador-font)
         (enabled msgGanhador-enabled)
         (vert-margin 2)
         (horiz-margin 2)
         (min-width 0)
         (min-height 0)
         (stretchable-width #f)
         (stretchable-height #f)
         (auto-resize #f)))
  (send dlogCampeonato show #t))

(module+ main (campeonatoPescaIFC-init))
