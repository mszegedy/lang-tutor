;;;; This is a demo file for the .ls format for lang-tutor.lisp.
;;;; A note on terminology: "literal symbol" refers to anything that doesn't
;;;; point to a rule, which includes non-printing symbols as well.
;;; Introduction
;; The INTRODUCTION tag is for the text that gets printed at the lesson start.
(introduction
 "Tagalog has no copula. The focus, the thing that the subject is being, ~
comes first, followed by the subject, marked with \"ang\". If the subject is ~
a pronoun, then it is not marked; pronouns simply inflect. Every character ~
is pronounced like its IPA equivalent, except <y>, which is pronounced [j]. ~
Stress is usually on the second-to-last syllable, unless marked with an ~
long. Consecutive vowels have a glottal stop, which tends to disappear in ~
fast speech.\n~
Words with accent on the last syllable have three kinds of diacritics: the ~
accent mark, such as in \"akó\", the grave mark, such as in \"batà\", and the ~
circumflex, such as in \"hindî\". The accent means that the stress is on the ~
\(short) last syllable, but the vowel isn't followed by a glottal stop. The ~
grave mark means that the stress is on the last syllable, and it is followed ~
by a glottal catch. The circumflex means that the last syllable is followed ~
by a glottal catch, but isn't stressed much compared to the preceding ~
syllables, and tends to lose its stress entirely to succeeding words.\n~
Normal written Tagalog does not include the diacritics. They are only for the ~
benefit of learners.")
;;; Rules
;; These indicate the rules for the language that the user is learning. Each
;; rule is the rule name, followed by the different possible sequences it could
;; expand to. Items in the sequence that point to rules are encased in a
;; list. Every rule should be prefixed with the ISO 639-1 two-letter code for
;; the language.
(left-rules
 (tl-sentence
  (<capital> (tl-linking-sentence) <period>))
 (tl-linking-sentence
  ((tl-linking-predicate) (tl-ang-noun-phrase)))
 (tl-linking-predicate
  ((tl-noun)))
 (tl-ang-noun-phrase
  (ang (tl-noun))
  ((tl-ang-pronoun)))
 (tl-noun
  ((tl-w-lalaki))
  ((tl-w-babae))
  ((tl-w-bata)))
 (tl-ang-pronoun
  ((tl-w-ako))
  ((tl-w-ka))
  ((tl-w-siya))))
;; These are rules for producing words. They are regular rules; the only
;; difference is that they are defined using a shorthand. The first element in
;; each word declaration should be the word name, followed by either a single
;; symbol that is the literal word, or a sequence of literal symbols encased in
;; a list (at which point it is no different from a standard rule
;; declaration). The name of the word for every rule should be prefixed by the
;; letter w, following the ISO 639-1 code that every other rule gets as well.
(left-words
 (tl-w-lalaki lalaki)
 (tl-w-babae babae)
 (tl-w-bata batà)
 (tl-w-ako akó)
 (tl-w-ka ka)
 (tl-w-siya siyá))
;; These indicate the rules for the language that the user already knows. They
;; are defined the same way as the rules for the left language.
(right-rules
 (en-sentence
  (<capital> (en-linking-sentence) <period>))
 (en-linking-sentence
  ((en-linking-subject-and-verb) (en-noun-phrase)))
 (en-linking-subject-and-verb
  ((en-w-i) am)
  ((en-w-you) are)
  ((en-third-person-singular-pronouns) is)
  ((en-singular-noun-phrase) is))
 (en-third-person-singular-pronouns
  ((en-w-he))
  ((en-w-she))
  ((en-w-it)))
 (en-noun-phrase
  ((en-singular-noun-phrase)))
 (en-singular-noun-phrase
  ((en-article) (en-singular-noun)))
 (en-article
  ((en-w-a))
  ((en-w-the)))
 (en-singular-noun
  ((en-w-man))
  ((en-w-boy))
  ((en-w-woman))
  ((en-w-girl))
  ((en-w-child))))
;; These are the rules for the right-side words. The ones here demonstrate that
;; a word can be a sequence, as opposed to a single symbol, with EN-W-I.
(right-words
 (en-w-i (<capital> i))
 (en-w-you you)
 (en-w-he he)
 (en-w-she she)
 (en-w-it it)
 (en-w-a a)
 (en-w-the the)
 (en-w-man man)
 (en-w-boy boy)
 (en-w-woman woman)
 (en-w-girl girl)
 (en-w-child child))
;;; Links
;; The "links" between the left-side rules and right-side rules. Each
;; declaration consists of a two-element list of the LEFT-NAME and RIGHT-NAME
;; of the link, respectively, followed by a list for each link that uses that
;; combination of names. Each such list consists of a two-element list that
;; contains the link's LEFT-INDEX and RIGHT-INDEX, followed by a list that
;; contains each pair of linked indices for that link, from which the LINK-MAP
;; may be constructed. A shorthand may be used for declaring links wherein one
;; just writes a two-element list containing a LEFT-NAME and a RIGHT-NAME. This
;; is short for a link between the respective first elements of the respective
;; first sequences of those rules; i.e.:
;;
;;  (left-name right-name)
;;
;; is short for
;;
;;  ((left-name right-name)
;;   ((0 0)
;;    ((0 0))))
(links
 ((tl-sentence en-sentence)
  ((0 0)
   ((1 1))))
 ((tl-linking-sentence en-linking-sentence)
  ((0 0)
   ((0 1)
    (1 0))))
 (tl-linking-predicate en-noun-phrase)
 ((tl-linking-predicate en-singular-noun-phrase)
  ((0 0)
   ((0 1)))))
;; These define many links at once: every instance of the rule on the left will
;; get linked to every instance of the rule on the right. Ideally, each of
;; these rules is a word, and is used only once, but technically this can be
;; used to link any two rules.
(word-links
 (tl-w-ako en-w-i)
 (tl-w-ka en-w-you)
 (tl-w-siya en-w-he)
 (tl-w-siya en-w-she)
 (tl-w-lalaki en-w-man)
 (tl-w-lalaki en-w-boy)
 (tl-w-babae en-w-woman)
 (tl-w-bata en-w-child))
