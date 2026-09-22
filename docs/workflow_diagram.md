# Workflow diagram

Placeholder. The one page picture of the pipeline goes here, exported as
`workflow_diagram.png` and embedded in `protocol.md`.

Until it is drawn, the seven steps in words:

```
  keyword_list.R
        |
   1 SEARCH      OpenAlex, Africa filter, year filter
        |        catalogues/search_raw.csv
   2 DEDUP       DOI exact, then fuzzy title
        |        outputs/02_dedup/records_deduped.csv
   3 SCREEN      model reads title and abstract, code rules check it
        |        outputs/03_screen/screen_ruled.csv     unsure goes to a person
   4 FETCH       Unpaywall, then the DOI, then the publisher
        |        outputs/04_fulltext/pdf/
   5 EXTRACT     model reads the full text, every value carries a page
        |        outputs/05_extract/extracted_verbatim.csv
   6 HARMONISE   controlled vocabularies, units standardised
        |        outputs/06_harmonise/extracted_harmonised.csv
   7 PUBLISH     Excel parameter database, cost report, quality score
                 outputs/07_publish/cc4a_parameters_latest.xlsx
```
