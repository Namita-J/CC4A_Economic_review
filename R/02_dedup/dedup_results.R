# What it does: Takes the raw search results and leaves one row per study.
#   Exact DOI match first, then fuzzy title match with stringdist for the
#   records that carry no DOI or carry a different one. Nothing is deleted:
#   the copies that are dropped are written to a register saying which row
#   was kept and why.
# Reads: catalogues/search_raw.csv
# Writes: outputs/02_dedup/records_deduped.csv    one row per study
#         outputs/02_dedup/duplicate_register.csv the copies taken out
# Flags: --threshold=  fuzzy title distance, default 0.10 (Jaro-Winkler)
#        --report      write the register and change nothing else
#        --limit=      test on the first n records
#
# Run with:
#   Rscript R/02_dedup/dedup_results.R --report
#   Rscript R/02_dedup/dedup_results.R

root <- rprojroot::find_root(rprojroot::has_file("CC4A.Rproj"))
source(file.path(root, "R/00_shared/paths.R"))
source(file.path(root, "R/00_shared/utils.R"))

# Which copy is kept when two rows are the same study, in order:
#   1. the row with a DOI
#   2. the row with an open access URL
#   3. the row with the longer abstract
#   4. the row found first
KEEP_RULE <- c("has_doi", "has_oa_url", "longer_abstract", "first_seen")

# Jaro-Winkler distance below this counts as the same title. Raise it and
# real pairs slip through; lower it and different studies get merged. Check
# any change against the register before trusting it.
TITLE_DISTANCE_DEFAULT <- 0.10

# TODO
# 1. read FILE_SEARCH_RAW
# 2. normalise_doi() and normalise_title() from utils.R
# 3. group by normalised DOI, mark exact duplicates
# 4. for the rest, block on publication year and first author surname so the
#    fuzzy comparison stays cheap, then stringdist::stringdistmatrix() with
#    method = "jw" inside each block
# 5. apply KEEP_RULE within each cluster, assign a study_id to the cluster
# 6. write FILE_DEDUP_CLEAN and FILE_DEDUP_REPORT
stop("not implemented yet")
