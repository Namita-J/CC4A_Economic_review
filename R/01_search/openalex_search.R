# What it does: Queries the OpenAlex works API with the keyword list, keeps
#   the records with an African country tie, and writes one row per record
#   with the fields the later steps need. Resumable: a query already run is
#   skipped unless --refresh is given.
# Reads: catalogues/keyword_list.R
#        catalogues/vocab_practices.csv (practice terms feed the queries)
# Writes: catalogues/search_raw.csv     one row per record, all queries
#         outputs/01_search/search_log.csv  one row per query, with counts
# Flags: --block=       run one keyword block only (practice, cost, adoption)
#        --from-year=   override YEAR_MIN from paths.R
#        --to-year=     override YEAR_MAX from paths.R
#        --limit=       stop after this many records, for a test run
#        --refresh      rerun queries already in the log
#        --dry          print the queries and the expected counts, fetch none
#
# Run with:
#   Rscript R/01_search/openalex_search.R --dry
#   Rscript R/01_search/openalex_search.R --block=cost --limit=200

root <- rprojroot::find_root(rprojroot::has_file("CC4A.Rproj"))
source(file.path(root, "R/00_shared/paths.R"))
source(file.path(root, "R/00_shared/utils.R"))
source(FILE_KEYWORDS) # absolute, defined in paths.R

# OpenAlex asks for a contact address and gives faster service to requests
# that carry one. See .Renviron.example.
OPENALEX_BASE <- "https://api.openalex.org/works"

# Columns every search writes, whatever the query was. Step 2 depends on
# this shape.
SEARCH_COLS <- c(
  "record_id",      # OpenAlex work id, the short form such as W2741809807
  "doi",            # normalised, no https prefix
  "title",
  "abstract",
  "publication_year",
  "journal",
  "authors",        # semicolon separated
  "country_iso2",   # semicolon separated, from the institution tie
  "type",           # article, book-chapter, report, dissertation
  "is_oa",
  "oa_url",
  "cited_by_count",
  "query_block",    # which keyword block found it
  "query_string",   # the exact query sent
  "retrieved_on"
)

# TODO
# 1. flags <- parse_flags()
# 2. build the query set from keyword_list.R: the practice block crossed with
#    the cost block, and the practice block crossed with the adoption block
# 3. add the Africa filter server side (institutions.country_code) and the
#    year filter, so the result set is small before it is downloaded
# 4. page through with cursor paging, 200 per page, fetch_polite() between
#    pages, and stop at --limit
# 5. reconstruct the abstract from OpenAlex's inverted index
# 6. bind the pages, add the query columns, write FILE_SEARCH_RAW
# 7. append one row per query to FILE_SEARCH_LOG: query, returned, kept, date
stop("not implemented yet")
