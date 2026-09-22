# What it does: Gets the full text of every in scope record. Tries the open
#   access location Unpaywall gives for the DOI, then the OpenAlex open
#   access URL, then the publisher link. Every downloaded file is checked
#   before it is kept: it has to be a PDF and it has to hold readable text.
#   Records with no free copy are listed for a person to fetch by hand.
# Reads: outputs/03_screen/screen_ruled.csv  the in scope records only
# Writes: outputs/04_fulltext/pdf/<record_id>.pdf
#         outputs/04_fulltext/fulltext_index.csv  one row per record, with
#           the path, the source that worked, and the failure reason
# Flags: --limit=   fetch this many, for a test run
#        --retry    try again for the records that failed last time
#        --dry      list what would be fetched and from where
#
# Run with:
#   Rscript R/04_fetch/fetch_fulltext.R --dry
#   Rscript R/04_fetch/fetch_fulltext.R --limit=20

root <- rprojroot::find_root(rprojroot::has_file("CC4A.Rproj"))
source(file.path(root, "R/00_shared/paths.R"))
source(file.path(root, "R/00_shared/utils.R"))

UNPAYWALL_BASE <- "https://api.unpaywall.org/v2/"

# Tried in this order. The first one that yields a readable PDF wins, and
# the winner is recorded, so it is clear where each full text came from.
FETCH_SOURCES <- c(
  "unpaywall",   # best_oa_location$url_for_pdf for the DOI
  "openalex_oa", # the oa_url the search step already carries
  "doi_direct",  # https://doi.org/<doi>, follow redirects
  "landing_page" # the publisher page, look for a PDF link
)

# A file is kept only when all of these hold. A login wall saved as a PDF
# passes the first check and fails the rest.
PDF_CHECKS <- c(
  "is_pdf",         # the magic bytes say PDF
  "opens",          # pdftools can read it
  "has_text",       # more than a few hundred characters of text, not a scan
  "min_pages"       # at least two pages
)

# Why a record has no full text. Written to the index so the hand fetch list
# is short and honest. A single failed request is not proof of a paywall:
# every source in FETCH_SOURCES has to fail first.
FAIL_REASONS <- c(
  "no_doi", "no_oa_location", "download_failed", "not_a_pdf",
  "scanned_no_text", "paywalled"
)

# TODO
# 1. read FILE_SCREEN_RULED, keep verdict_ruled == "in"
# 2. skip records already in FILE_FETCH_INDEX unless --retry
# 3. Unpaywall needs UNPAYWALL_EMAIL on every request, stop early if unset
# 4. walk FETCH_SOURCES per record through fetch_polite()
# 5. run PDF_CHECKS, delete anything that fails, record the reason
# 6. write the file as <record_id>.pdf so the path is derivable, never
#    depend on the publisher's filename
# 7. append to FILE_FETCH_INDEX after every record, so a stopped run resumes
stop("not implemented yet")
