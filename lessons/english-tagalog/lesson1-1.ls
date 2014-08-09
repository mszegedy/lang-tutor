;;;; This is a demo file for the .ls format for lang-tutor.lisp.
;;;; A note on terminology: "literal symbol" refers to anything that doesn't point to a rule, which
;;;; includes non-printing symbols as well.
;;; Introduction
;; The INTRODUCTION tag is for the text that gets printed at the lesson start.
(introduction
 "Tagalog has no copula. The focus, the thing that the subject is being, comes first, followed by ~
 the subject, marked with \"ang\". If the subject is a pronoun, then it is not marked; pronouns ~
 simply inflect. Every character is pronounced like its IPA equivalent, except <y>, which is ~
 pronounced [j]. Stress is usually on the second-to-last syllable, unless marked with an accent ~
 mark. The stressed syllable is long, except in the case that it is the last (see ~
 below). Consecutive vowels have a glottal stop, which tends to disappear in fast speech.\n~
 Words with accent on the last syllable have three kinds of diacritics: the accent mark, such as ~
 in \"akó\", the grave mark, such as in \"batà\", and the circumflex, such as in \"hindî\". The ~
 accent means that the stress is on the \(short) last syllable, but the vowel isn't followed by a ~
 glottal stop. The grave mark means that the stress is on the last syllable, and it is followed ~
 by a glottal catch. The circumflex means that the last syllable is followed by a glottal catch, ~
 but isn't stressed much compared to the preceding syllables, and tends to lose its stress ~
 entirely to succeeding words.\n~
 Normal written Tagalog does not include the diacritics. They are only for the benefit of ~
 learners.")
;;; Rules
;; This tells what rule to start with on the left for making sentences.
(left-root-rule tl-sentence)
;; These indicate the rules for the language that the user is learning. Each rule is the rule name,
;; followed by the different possible sequences it could expand to. Items in the sequence that
;; point to rules are encased in a list. Every rule should be prefixed with the ISO 639-1
;; two-letter code for the language. No rule name may consist entirely of numeric digits (or else
;; it would lead to ambiguity when defining links).
(left-rules
 (tl-sentence
  (<capital> (tl-linking-sentence) <period>))
 (tl-linking-sentence
  ((tl-linking-predicate) (tl-ang-noun-phrase)))
 (tl-linking-predicate
  ((tl-ang-and-noun))
  ((tl-noun)))
 (tl-ang-noun-phrase
  ((tl-ang-and-noun))
  ((tl-ang-pronoun)))
 (tl-ang-and-noun
  (ang (tl-noun)))
 (tl-noun
  ((tl-w-lalaki))
  ((tl-w-babae))
  ((tl-w-bata)))
 (tl-ang-pronoun
  ((tl-w-ako))
  ((tl-w-ka))
  ((tl-w-siya))))
;; These are rules for producing words. They are regular rules; the only difference is that they
;; are defined using a shorthand. The first element in each word declaration should be the word
;; name, followed by either a single symbol that is the literal word, or a sequence of literal
;; symbols encased in a list (at which point it is no different from a standard rule
;; declaration). The name of the word for every rule should be prefixed by the letter w, following
;; the ISO 639-1 code that every other rule gets as well.
(left-words
 (tl-w-lalaki lalaki)
 (tl-w-babae babae)
 (tl-w-bata batà)
 (tl-w-ako akó)
 (tl-w-ka ka)
 (tl-w-siya siyá))
;; This indicates the rule to start with on the right for making sentences.
(right-root-rule en-sentence)
;; These indicate the rules for the language that the user already knows. They are defined the same
;; way as the rules for the left language.
(right-rules
 (en-sentence
  (<capital> (en-linking-sentence) <period>))
 (en-linking-sentence
  ((en-linking-subject-and-verb) (en-noun-phrase)))
 (en-linking-subject-and-verb
  ((en-w-i) am)
  ((en-w-you) are)
  ((en-third-person-singular-pronoun) is)
  ((en-singular-noun-phrase) is))
 (en-third-person-singular-pronoun
  ((en-w-he))
  ((en-w-she))
  ((en-w-it)))
 (en-noun-phrase
  ((en-singular-noun-phrase)))
 (en-singular-noun-phrase
  (the (en-singular-noun))
  (a (en-singular-noun)))
 (en-singular-noun
  ((en-w-man))
  ((en-w-boy))
  ((en-w-woman))
  ((en-w-girl))
  ((en-w-child))))
;; These are the rules for the right-side words. The ones here demonstrate that a word can be a
;; sequence, as opposed to a single symbol, with EN-W-I.
(right-words
 (en-w-i (<capital> i))
 (en-w-you you)
 (en-w-he he)
 (en-w-she she)
 (en-w-it it)
 (en-w-man man)
 (en-w-boy boy)
 (en-w-woman woman)
 (en-w-girl girl)
 (en-w-child child))
;;; Links
;; The "links" between the left-side rules and right-side rules. Each declaration consists of a
;; two-element list of the LEFT-NAME and RIGHT-NAME of the link, respectively, followed by a list
;; for each link that uses that combination of names. Each such list consists of a two-element list
;; that contains the link's LEFT-INDEX and RIGHT-INDEX, followed by a list that contains each pair
;; of linked indices for that link, from which the LINK-MAP may be constructed. Example:
;;
;;  ((left-rule right-rule)
;;   ((4 6)
;;    ((2 3)
;;     (0 1)))
;;   ((5 10)
;;    ((98 21))))
;;
;; This links the third element in the fifth sequence of LEFT-RULE with the fourth element in the
;; seventh sequence of RIGHT-RULE, the first element in the fifth sequence of LEFT-RULE with the
;; second element in the seventh sequence of RIGHT-RULE, and the ninety-ninth element in the sixth
;; sequence in LEFT-RULE with the twenty-second element in the eleventh sequence in RIGHT-RULE.
;; A shorthand may be used for declaring links wherein one just writes a two-element list
;; containing a LEFT-NAME and a RIGHT-NAME. This is short for a link between the respective first
;; elements of the respective first sequences of those rules. Example:
;;
;;  (left-rule right-rule)
;;
;; is short for
;;
;;  ((left-rule right-rule)
;;   ((0 0)
;;    ((0 0))))
;;
;; Another, more computationally advanced shorthand may also be used: instead of specifying a pair
;; of sequence indices, followed by a list of pairs of element indices, one may specify a list of
;; pairs of names of rules. This will cause every instance of the first specified rule in the
;; sequences of the overarching left rule to be linked to every instance of the second specified
;; rule in the overarching right rule. One may also replace a pair of item indices with a pair of
;; rule names, causing the same effect but localized to that sequence. Both of these are only
;; advisable when each rule is sure to only occur once, and is more computationally expensive than
;; just specifying pairs of indices. It does, however, lead to a more readable lesson format. One
;; may mix these two shorthands with the explicit, index-oriented format.
(links
 ((tl-sentence en-sentence)
  ((tl-linking-sentence en-linking-sentence)))
 ((tl-linking-sentence en-linking-sentence)
  ((tl-linking-predicate en-noun-phrase)
   (tl-ang-noun-phrase en-linking-subject-and-verb)))
 ((tl-linking-sentence en-noun-phrase)
  ((tl-linking-predicate en-singular-noun-phrase)))
 ((tl-linking-predicate en-singular-noun-phrase)
  ((0 0)
   ((tl-ang-and-noun en-singular-noun)))
  ((1 1)
   ((tl-noun en-singular-noun))))
 ((tl-ang-and-noun en-singular-noun-phrase)
  ((0 0)
   ((tl-noun en-singular-noun))))
 ((tl-noun en-singular-noun)
  ((tl-w-lalaki en-w-man)
   (tl-w-lalaki en-w-boy)
   (tl-w-babae en-w-woman)
   (tl-w-babae en-w-girl)))

 ((tl-ang-noun-phrase en-linking-subject-and-verb)
  ((tl-noun en-singular-noun)))
 ((tl-ang-noun-phrase en-linking-sentence)
  ((tl-ang-pronoun en-linking-subject-and-verb)))
 ((tl-ang-pronoun en-linking-subject-and-verb)
  ((tl-w-ako en-w-i)
   (tl-w-ka en-w-you)
   (tl-w-siya en-third-person-singular-pronoun))))
