(introduction
 "Tagalog has no copula. The focus, the thing that the subject is being, ~
 comes first, followed by the subject, marked with \"ang\". If the subject is ~
 a pronoun, then it is not marked; pronouns simply inflect.")
(left-rules
 (tl-sentence
  ((tl-linking-sentence) <period>))
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
(left-words
 (tl-w-lalaki lalaki)
 (tl-w-babae babae)
 (tl-w-bata bata)
 (tl-w-ako ako)
 (tl-w-ka ka)
 (tl-w-siya siya))
(right-rules
 (en-sentence
  ((en-linking-sentence) <period>))
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
(links
 (tl-sentence en-sentence)
 ((tl-linking-sentence en-linking-sentence)
  ((0 0)
   ((0 1)
    (1 0))))
 (tl-linking-predicate en-noun-phrase)
 ())