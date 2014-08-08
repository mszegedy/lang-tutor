;;;; lang-tutor.lisp by mszegedy
;;;; This program is free software: you can redistribute it and/or modify
;;;; it under the terms of the GNU General Public License as published by
;;;; the Free Software Foundation, either version 3 of the License, or
;;;; (at your option) any later version.
;;;;
;;;; This program is distributed in the hope that it will be useful,
;;;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;;; GNU General Public License for more details.
;;;;
;;;; You should have received a copy of the GNU General Public License
;;;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;;; This file is a pretty good demonstration of my programming ability.
;;;; Pros:
;;;; - Reasonably-well documented
;;;; - Adheres to Google's Common Lisp Style Guide (mostly)
;;;; - Relies more on smart data structures than smart code
;;;; - Highly compartmentalized, so pretty flexible
;;;; - Third-party code is properly attributed
;;;; - Written in Lisp
;;;; - Contains a Dragonball Z joke
;;;; Cons:
;;;; - Contains some complicated stuff that a smarter person could simplify
;;;; - Contains at least one hack
;;;; - Has a global variable
;;;; - Doesn't just do one thing well
;;;; - No consistent naming scheme for functions or variables
;;;; - Highly compartmentalized, so pretty bloated
;;;; - Written in Lisp

(defconstant +debug+ t
  "Whether or not to show debugging text.")

;;;;;;;;;;;;;;;;;
;;; Constants ;;;
;;;;;;;;;;;;;;;;;
(defconstant +non-printing-words+ '(<blank> <close-quote> <combiner>
                                    <combining-apostrophe> <comma>
                                    <exclamation> <open-quote> <period>
                                    <question> <space>)
  "A list of symbols that aren't meant to be printed. This includes all
meta-symbols.")

;;;;;;;;;;;;;;
;;; Macros ;;;
;;;;;;;;;;;;;;
(defmacro game-in ()
  "Standard input macro."
  `(split-spaces (read-line)))
(defmacro game-out (destination control-string &rest format-arguments)
  "Standard output macro."
  `(prog1
       (format ,destination ,control-string ,@format-arguments)
     (finish-output nil)))
(defmacro debug-out (control-string &rest format-arguments)
  "Standard debug output macro. Puts a \"@ \" before every line."
  (if +debug+
      `(game-out
        t
        ,(concatenate
          'string
          "@ "
          ;; This could probably be optimized using POSITION
          (loop for i from 0 to (1- (length control-string))
                if (and (>= i 2)
                        (equal (subseq control-string (- i 2) i) "~%"))
                  collect #\@ and
                  collect #\Space
                collect (elt control-string i)))
        ,@format-arguments)))
(defmacro ini-hash-table (pairs)
  "Makes a hash table from a flat list of key-value pairs. Call with
`#.'. Credit to Antonio Bonifati from StackOverflow for this implementation."
  `(let ((hash (make-hash-table)))
     (loop for (key value) on ,pairs by #'cddr do
       (setf (gethash key hash) value))
     hash))

;;;;;;;;;;;;;;;;;
;;; Functions ;;;
;;;;;;;;;;;;;;;;;
;;; General helping functions
(defun hash-table-keys (hash-table)
  "Returns a list with the keys of a hash table."
  (if (hash-table-p hash-table)
      (loop for key being the hash-keys of hash-table collect key)))
(defun split-spaces (string)
  "Splits a string into smaller strings using continuous groups of spaces as
separators."
  ;; A more elegant implementation would use FORMAT, I think.
  (mapcar
   (lambda (x) (intern (string-upcase x)))
   ;; Stolen from The Common Lisp Cookbook.
   (loop for i = 0 then (1+ j)
         as j = (position #\Space string :start i)
         if (not (equal (subseq string i j) "")) ; TODO: optimize
           collect (subseq string i j)
         while j)))
;;; Program-specific functions
(defun print-sequence (sequence &key (destination t))
  "Prints out a sequence in a manner appropriate for human
consumption. DESTINATION controls the destination stream, which uses the same
scheme as GAME-OUT (which uses the same scheme as FORMAT)."
  (debug-out "Printing sequence: ~s~%" sequence)
  (game-out
   destination
   (reduce
    (lambda (first-string second-string)
      (concatenate 'string first-string second-string))
    (let ((capitalp t)
          (print-space-next-p t))
      (loop
        for item in sequence
        for index from 0
        collect
        (let ((non-printing-word-p (member item +non-printing-words+)))
         (concatenate
          'string
          (prog1
              (if (and (not (= 0 index))
                       (not non-printing-word-p)
                       print-space-next-p)
                  " ")
            (if (and (not print-space-next-p)
                     (not non-printing-word-p))
                (setf print-space-next t)))
          (if (not non-printing-word-p)
              (if capitalp
                  (game-out nil "~:(~a~)" item)
                  (game-out nil "~(~a~)" item)))
          (progn
            (if (and (> index 0)
                     capitalp)
                (setf capitalp nil))
            (cond
              ((eql item '<capital>)
               (setf capitalp t))
              ((eql item '<combiner>)
               (setf print-space-next-p nil)))
            (cond
              ((eql item '<close-quote>)
               "\"")
              ((eql item '<combining-apostrophe>)
               (setf print-space-next-p nil)
               "'")
              ((eql item '<comma>)
               ",")
              ((eql item '<exclamation>)
               "!")
              ((eql item '<open-quote>)
               (setf print-space-next-p nil)
               " \"")
              ((eql item '<period>)
               ".")
              ((eql item '<question>)
               "?")
              ((eql item '<space>)
               " "))))))))))
(defun select-best-link (links &key (criterion 'maximize-mystery))
  "Gets the best link from a list of links according to some criterion. Not
guaranteed to be deterministic."
  (cond
    ((eql criterion 'maximize-mystery)
     ;; Get the link with the highest mystery.
     (let ((best-link (car links)))
       (loop
         for link in links
         if (> (mystery link) (mystery best-link))
           do (setf best-link link))
       best-link))))
(defun process-file)

;;;;;;;;;;;;;;;;
;;; Generics ;;;
;;;;;;;;;;;;;;;;
;; First appear in RULE-POINTER
;; First appear in RULE
;; First appear in LINK
(defgeneric copy-with-index-reset (link &key side)
  (:documentation
   "Returns a copy of the link with the index on one side or the other
reset to 0. The keyword argument SIDE controls which side that is: 'LEFT will
make it the left side, 'RIGHT will make it the right side, and anything else,
such as 'NEITHER, will do neither side. (Please don't use this to deepcopy.)"))
(defgeneric downgrade-mystery (link &key multiplier)
  (:documentation
   "Reduces the MYSTERY value of the link by a multiplier."))
(defgeneric map-index (link index)
  (:documentation
   "Gives the matching right-side index of a left-side index."))
;; First appear in ENVIRONMENT
(defgeneric get-rule (environment id)
  (:documentation
   "Gets an item with the specified id and type from the environment."))
(defgeneric get-link (environment
                      &key
                        left-name
                        right-name
                        left-index
                        right-index)
  (:documentation
   "Gets the link with the associated information, if any. All of the keyword
arguments must be provided!"))
(defgeneric add-link (environment link)
  (:documentation
   "Adds the link to the environment."))
(defgeneric sequence-expansions (environment sequence)
  (:documentation
   "Makes a list of all possible expansions of a sequence."))
(defgeneric match-answer (environment answer sequence
                          &key
                            answer-type
                            ignore-case-p
                            ignore-punctuation-p
                            ignore-spaces-p
                            sloppyp)
  (:documentation
   "Checks whether an answer is able to be generated by a particular
sequence. The keyword arguments are all optional. ANSWER-TYPE should be set to
STRING when the answer is a string, or SEQUENCE when the answer is a
sequence. The rest of the arguments determine how strict the matching is."))
(defgeneric expand-rule-sequence (environment
                                  &key
                                    left-sequence
                                    right-sequence
                                    link)
  (:documentation
   "Randomly expands a sequence, LEFT-SEQUENCE, into a list of symbols. A
RIGHT-SEQUENCE and a LINK may optionally be provided so that the RIGHT-SEQUENCE
is expanded as well along with the LEFT-SEQUENCE, to its most general possible
form that may or may not still include RULE-POINTERs, and returned as the
second return value."))

;;;;;;;;;;;;;;;
;;; Objects ;;;
;;;;;;;;;;;;;;;

(defclass rule-pointer ()
  ((name
    :accessor name
    :initarg :name
    :documentation
    "The name of the rule that the pointer refers to."))
  (:documentation
   "Stores the name of a rule for another rule to point to."))

(defclass rule ()
  ((name
    :accessor name
    :initarg :name
    :documentation
    "The unique identifier symbol of the rule.")
   (sequences
    :accessor sequences
    :initarg :sequence
    :initform nil
    :documentation
    "The list of possible sequences the rule can expand to. A list of lists of
  symbols and RULE-POINTERs."))
  (:documentation
   "A rule for making parts of sentences with. Expands to a sequence of rules
  and sentences."))

(defclass link ()
  ((left-name
    :accessor left-name
    :initarg :left-name
    :documentation
    "The name of the rule on the left.")
   (right-name
    :accessor right-name
    :initarg :right-name
    :documentation
    "The name of the rule on the right.")
   (left-index
    :accessor left-index
    :initarg :left-index
    :documentation
    "The index of the sequence for the rule on the left. If it's a word,
  the index is 0.")
   (right-index
    :accessor right-index
    :initarg :right-index
    :documentation
    "The index of the sequence for the rule on the right. If it's a word,
  the index is 0.")
   (link-map
    :accessor link-map
    :initarg :link-map
    :initform (make-hash-table)
    :documentation
    "A hash table that maps an index on the left side to an index on the right
  side.")
   (mystery
    :accessor mystery
    :initform 1.0
    :documentation
    "How well the learner knows the link. 1.0 is completely unkown, 0.0 is
  completely known."))
  (:documentation
   "A link between two rules, that tells what items are linked inside
  them."))
(defmethod copy-with-index-reset ((link link) &key side)
  (make-instance
   'link
   :left-name (left-name link)
   :right-name (right-name link)
   :left-index (if (eql side 'left)
                   0
                   (left-index link))
   :right-index (if (eql side 'right)
                    0
                    (right-index link))))
(defmethod downgrade-mystery ((link link) &key (multiplier 0.99))
  (setf (mystery link) (* (mystery link) multiplier)))
(defmethod map-index ((link link) index)
  (gethash index (link-map link)))

(defclass environment ()
  ((rules
    :accessor rules
    :initarg :rules
    :initform (make-hash-table)
    :documentation
    "The rules in the environment.")
   (links
    :accessor links
    :initarg :links
    :initform (make-hash-table)
    :documentation
    "The links in the environment. Each link is indexed by a four-element list,
  consisting of, respectively, its LEFT-NAME, RIGHT-NAME, LEFT-INDEX, and
  RIGHT-INDEX."))
  (:documentation
   "Stores the words, rules, and links for the lesson."))
(defmethod get-rule ((environment environment) rule-name)
  (gethash rule-name (rules environment)))
(defmethod get-link ((environment environment)
                     &key
                       left-name
                       right-name
                       left-index
                       right-index)
  (gethash (list left-name right-name left-index right-index)
           (links environment)))
(defmethod add-link ((environment environment) (link link))
  (setf (gethash (list (left-name link)
                       (right-name link)
                       (left-index link)
                       (right-index link))
                 (links environment))
        link))
(defmethod sequence-expansions ((environment environment) sequence)
  (let ((first-rule-pointer-index
          ;; If the loop finishes without finding a RULE-POINTER, it returns
          ;; nil
          (loop
            for item in sequence
            for index from 0
            if (typep 'rule-pointer item)
              return index)))
    (if first-rule-pointer-index
        (let* ((rule-pointer (elt sequence first-rule-pointer-index))
               (rule (get-rule environment (name rule-pointer)))
               (rule-sequences (sequences rule)))
          (loop
            for rule-sequence in rule-sequences
            append
            (sequence-expansions
             environment
             (append
              (subseq sequence 0 (1- first-rule-pointer-index))
              rule-sequence
              (nthcdr first-rule-pointer-index sequence)))))
        ;; If SEQUENCE doesn't contain a RULE-POINTER object
        (list sequence))))
(defmethod match-answer ((environment environment) answer sequence
                         &key
                           (answer-type 'string)
                           (ignore-case-p t)
                           (ignore-punctuation-p t)
                           (ignore-spaces-p nil)
                           (sloppyp nil))
  (let* ((expansions (sequence-expansions environment sequence))
         (expansion-strings (mapcar
                             (lambda (expansion)
                               (print-sequence nil expansion))
                             expansions))
         (answer-string (cond
                          ((eql answer-type 'string)
                           answer)
                          ((eql answer-type 'sequence)
                           (print-sequence nil answer)))))
    (flet ((modify (string)
             (let* ((case-form
                      (if ignore-case-p
                          (string-upcase string)
                          string))
                    (punctuation-form
                      (if ignore-punctuation-p
                          (concatenate
                           'string
                           (loop
                             for i from 0 to (1- (length case-form))
                             with this-char = (elt case-form i)
                             if (not (find this-char
                                           ".?!,;:'\"()[]{}<>"))
                               collect this-char))
                          case-form))
                    (spaces-form ; this isn't even its final form
                      (if ignore-spaces-p
                          (concatenate
                           'string
                           (loop
                             for i from 0 to (1- (length punctuation-form))
                             with this-char = (elt punctuation-form i)
                             if (not (char= this-char #\Space))
                               collect this-char))
                          punctuation-form)))
               spaces-form))
           (test (string-1 string-2)
             (if sloppyp
                 ;; Dynamic programming implementation of edit distance
                 ;; From Rosetta Code
                 ;; Returns t if edit distance is greater than MAX-DISTANCE
                 (let* ((max-distance 2)
                        (length-1 (length string-1))
                        (length-2 (length string-2))
                        (rec (make-array (list (1+ length-1)
                                               (1+ length-2))
                                         :initial-element nil)))
                   (flet ((distance (x y)
                            (cond
                              ((= x 0) x)
                              ((= y 0) y)
                              ((aref rec x y) (aref rec x y))
                              (t
                               (setf (aref rec x y)
                                     (+ (if (char= (char string-1
                                                         (- length-1 x))
                                                   (char string-2
                                                         (- length-2 y)))
                                            0
                                            1)
                                        (min (distance (1- x) y)
                                             (distance x (1- y))
                                             (distance (1- x) (1- y))))))))))
                   (if (> max-distance (distance length-1 length-2))
                       t))
                 (equal first-string second-string))))
      (member (modify answer)
              (mapcar #'modify expansion-strings)
              :test #'test))))
(defmethod expand-rule-sequence ((environment environment)
                                 &key
                                   left-sequence
                                   right-sequence
                                   link)
  (let* ((right-result right-sequence)
         (left-result
           (loop
             for left-item in left-sequence
             for left-index from 0
             append
             (cond
               ((symbolp left-item)
                (list left-item))
               ((typep 'rule-pointer left-item)
                (let* ((left-rule (get-rule environment (name left-item)))
                       (left-sequences (if (and left-rule
                                                (typep 'rule left-rule))
                                           (sequences left-rule)))
                       (right-index (if link
                                        (map-index link left-index)))
                       (right-item (if right-index
                                       (elt right-sequence right-index)))
                       (right-rule (if (typep 'rule-pointer right-item)
                                       (get-rule environment
                                                 (name right-item)))))
                  (cond
                    (right-rule
                     (let* ((right-sequences (sequences right-rule))
                            ;; Get all valid links:
                            (next-links
                              (append
                               ;; Collect links that only expand the left rule
                               (loop
                                 for x from 0 to (length
                                                  (sequences left-rule))
                                 with
                                   this-link = ; this syntax is really stupid
                                             (get-link
                                              environment
                                              :left-name (name left-rule)
                                              :right-name (right-name link)
                                              :left-index x
                                              :right-index right-index)
                                 if this-link
                                   collect this-link)
                               ;; Collect links that only expand the right rule
                               (loop
                                 for x from 0 to (length
                                                  (sequences right-rule))
                                 with
                                   this-link =
                                             (get-link
                                              environment
                                              :left-name (left-name link)
                                              :right-name (name right-rule)
                                              :left-index left-index
                                              :right-index x)
                                 if this-link
                                   collect this-link)
                               ;; Collect links that expand both the left rule
                               ;; and the right rule
                               (loop
                                 for x from 0 to (length
                                                  (sequences left-rule))
                                 append
                                 (loop
                                   for y from 0 to (length
                                                    (sequences right-rule))
                                   with
                                     this-link =
                                               (get-link
                                                environment
                                                :left-name (name left-rule)
                                                :right-name (name right-rule)
                                                :left-index x
                                                :right-index y)
                                   if this-link
                                     collect this-link))))
                            (best-link (select-best-link next-links)))
                       (downgrade-mystery best-link)
                       (add-link environment best-link)
                       ;; The link tells the function what pair of sequences to
                       ;; use in the expansion. The one on the left is made
                       ;; part of the returned list, while the one on the right
                       ;; manually replaces the one at the corresponding index
                       ;; on the right.
                       (multiple-value-bind (left-expansion right-expansion)
                           (expand-rule-sequence
                            environment
                            :left-sequence
                            ;; Does the left rule expand?
                            (if (eql (left-name best-link) (left-name link))
                                (list left-rule)
                                (elt left-sequences (left-index best-link)))
                            :right-sequence
                            ;; Does the right rule expand?
                            (if (eql (right-name best-link) (right-name link))
                                (list right-rule)
                                (elt right-sequences (right-index best-link)))
                            :link
                            (copy-with-index-reset
                             best-link
                             :side
                             (cond
                               ((eql (left-name best-link) (left-name link))
                                'left)
                               ((eql (right-name best-link) (right-name link))
                                'right)
                               (t
                                'neither))))
                         (setf right-result
                               (append
                                (subseq right-result 0 right-index)
                                right-expansion
                                (subseq right-result (1+ right-index))))
                         left-expansion)))
                    (left-sequences
                     (expand-rule-sequence
                      environment
                      :left-sequence (elt
                                      left-sequences
                                      (random (length left-sequences))))))))
               (t
                (debug-out
                 "Error: item ~s of unknown type at index ~s in sequence ~s~%"
                 left-item
                 left-index
                 left-sequence))))))
    (values left-result right-result)))

(defclass lesson ()
  )
