;;;; This is a demo file for the .ls format for lang-tutor.lisp.
;;;; A note on terminology: "literal symbol" refers to anything that doesn't point to a rule, which
;;;; includes non-printing symbols as well.
;;; Introduction
;; The INTRODUCTION tag is for the text that gets printed at the lesson start.
(introduction
 "Tagalog is a topic-prominent language, meaning it emphasizes the difference between the topic ~
 and the comment. In Tagalog, the comment, the part of the sentence that's new information, comes ~
 first, followed by the topic, the part of the sentence that refers to something already known, ~
 which is marked with \"ang\". If the word is a pronoun, then it is not marked; pronouns simply ~
 inflect. Every character is pronounced like its IPA equivalent, except <y>, which is pronounced ~
 [j]. Stress is usually on the second-to-last syllable, unless marked with an accent mark. The ~
 stressed syllable is long, except in the case that it is the last (see below). Consecutive ~
 vowels have a glottal stop, which tends to disappear in fast speech.\n~
 Words with accent on the last syllable have three kinds of diacritics: the accent mark, such as ~
 in \"akó\", the grave mark, such as in \"batà\", and the circumflex, such as in \"hindî\". The ~
 accent means that the stress is on the \(short) last syllable, but the vowel isn't followed by a ~
 glottal stop. The grave mark means that the stress is on the last syllable, and it is followed ~
 by a glottal catch. The circumflex means that the last syllable is followed by a glottal catch, ~
 but isn't stressed much compared to the preceding syllables, and tends to lose its stress ~
 entirely to succeeding words. Normal written Tagalog does not include the diacritics. They are ~
 only for the benefit of learners.\n~
 Tagalog has no copula, meaning it does not have a word to indicate that something \"is\" ~
 something else. Instead, the predicate is written first, either with no case marker to indicate ~
 indefiniteness, or with \"ang\" to indicate that it is definite, followed by the subject, marked ~
 with \"ang\". \"X ang Y\" therefore translates to \"(The) Y is an X\", and \"Ang X ang Y\" ~
 translates to \"(The) Y is the X\".")
;;; Rules
;; This tells what rule to start with on the left for making sentences.
(left-root-rule tl-sentence)
;; These indicate the rules for the language that the user is learning. Each rule is the rule name,
;; followed by the different possible sequences it could expand to. Items in the sequence that
;; point to rules are encased in a list. If a possible result is a single symbol, then it may be
;; written without being in a list. Every rule should be prefixed with the ISO 639-1 two-letter
;; code for the language. Every word rule should have an additional -W as part of that prefix.
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
  ((tl-w-siya)))
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
  ((en-w-child)))
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
;; This specifies which rules are linked. The basic structure of each specification is
;;
;;  ((left-rule right-rule)
;;   ((left-sequence-index right-sequence-index)
;;    (((left-item index) (right-item index))
;;     ((left-item index) (right-item index))
;;     ...))
;;   ((left-sequence index right-sequence-index)
;;    (((left-item index) (right-item index))
;;     ...))
;;   ...)
;;
;; The first item of each specification is a two-element list specifying the rule in the left
;; language and the rule in the right language whose elements are linked. Each successive element
;; is a list whose structure is such that the first element is a two-element list that specifies
;; first the index of the sequence in the left rule that contains the linked items, and then the
;; index of the sequence in the right rule; and the second element is a list of two-element lists,
;; each containing two two-element lists that point to an element in the left sequence and an
;; element in the right sequence respectively. Each such two-element list consists of the name of a
;; rule, and a number indicating which occurrence of that rule should be linked; 0 links the first
;; occurrence in the sequence, 1 links the second occurrence in the sequence, etc. Example:
;;
;; ((tl-sentence en-sentence)
;;  ((0 0)
;;   (((tl-linking-sentence 0) (en-linking-sentence 0)))))
;;
;; This links the first instance of the rule TL-LINKING-SENTENCE in the first sequence in
;; TL-SENTENCE with the first instance of the rule EN-LINKING-SENTENCE in the first sequence in
;; EN-SENTENCE. If the index is 0, it is possible to use a shorthand and write only the name of the
;; linked item:
;;
;;  ((tl-sentence en-sentence)
;;   ((0 0)
;;    ((tl-linking-sentence en-linking-sentence))))
;;
;; It is possible to further shorten this by writing the two rules instead of the two indices and
;; forgoing the listing of the items altogether:
;;
;;  ((tl-sentence en-sentence)
;;   ((tl-linking-sentence en-linking-sentence)))
;;
;; This will link the first instance of TL-LINKING-SENTENCE the parser finds anywhere in
;; TL-SENTENCE with the first instance of EN-LINKING-SENTENCE. It is not possible to specify the
;; index of either rule, as this would lead to confusing code as well as a headache for the
;; parser. If you want to link multiple instances or non-initial instances, just specify the
;; sequences. Using this especially-condensed shorthand, it is possible to link more than once; for
;; example:
;;
;;  ((tl-linking-sentence en-linking-sentence)
;;   ((tl-linking-predicate en-noun-phrase)
;;    (tl-ang-noun-phrase en-linking-subject-and-verb)))
;;
;; This will link both the first instance of TL-LINKING-PREDICATE to the first instance of
;; EN-NOUN-PHRASE, as well as the first instance of TL-ANG-NOUN-PHRASE to the first instance of
;; EN-LINKING-SUBJECT-AND-VERB. The fact that they happen to be part of the same sequence is
;; irrelevant; they'd be linked regardless of their position.
;; It is possible to link an item to "nothing", instead of another item. The effect of this is that
;; only that item will expand in that step, as opposed to both items expanding at once. To
;; accomplish this, replace the place for the "empty" item with an asterisk:
;;
;;  ((tl-ang-and-noun en-singular-noun)
;;   ((tl-noun *)))
;;
;; This links the first instance of TL-NOUN in TL-ANG-AND-NOUN to "nothing", in the case that an
;; instance of TL-ANG-AND-NOUN is found linked to an instance of EN-SINGULAR-NOUN. TL-ANG-AND-NOUN
;; will expand to an instance of TL-NOUN, linked to the same instance of EN-SINGULAR-NOUN as its
;; parent was linked to before. It is of course also possible to specify particular indices when
;; linking to "nothing", both for the sequence and item; the following two examples both do the
;; same thing as what is written above:
;;
;;  ((tl-ang-and-noun en-singular-noun)
;;   ((0 *) ; use * for the sequence index of the nothing side
;;    ((tl-noun *))))
;;
;;  ((tl-ang-and-noun en-singular-noun)
;;   ((0 *)
;;    (((tl-noun 0) *))))
;;
;; Finally, it is possible to specify a list of flags after specific pairs of linked items:
;;
;;  ((tl-ang-pronoun en-linking-subject-and-verb)
;;   ((tl-w-ako en-w-i (learn)))) ; this has the flag LEARN
;;
;; Currently, there is only one possible flag, LEARN, which makes the program describe the link to
;; the reader the first time it uses is in a problem.
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
 ((tl-ang-and-noun en-singular-noun)
  ((tl-noun *)))
 ((tl-noun en-singular-noun)
  ((tl-w-lalaki en-w-man (learn))
   (tl-w-lalaki en-w-boy (learn))
   (tl-w-babae en-w-woman (learn))
   (tl-w-babae en-w-girl (learn))))
 ((tl-ang-noun-phrase en-linking-subject-and-verb)
  ((tl-ang-and-noun en-singular-noun-phrase)
   (tl-pronoun *)))
 ((tl-ang-and-noun en-singular-noun-phrase)
  ((0 0)
   ((tl-noun en-singular-noun))))
 ((tl-ang-pronoun en-linking-subject-and-verb)
  ((tl-w-ako en-w-i (learn))
   (tl-w-ka en-w-you (learn))
   (tl-w-siya en-third-person-singular-pronoun (learn)))))
