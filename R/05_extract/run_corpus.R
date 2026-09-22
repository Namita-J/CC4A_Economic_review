# What it does: Runs extract_verbatim.R over the whole corpus. Takes only the
#   records the screening judged in scope and the fetch step found a readable
#   full text for. Resumable: a record already extracted is skipped. With
#   --dry it plans and prices the run without calling a model.
# Reads: outputs/04_fulltext/fulltext_index.csv
#        outputs/03_screen/screen_ruled.csv
#        outputs/05_extract/extracted_verbatim.csv  to know what is done
# Writes: outputs/05_extract/extracted_verbatim.csv   appended per record
#         outputs/05_extract/verification_report.csv
#         outputs/logs/run_corpus_<stamp>.csv         one row per record
# Flags: --limit=     extract this many records
#        --practice=  only records whose practice guess matches
#        --redo       extract again even when the record is done
#        --dry        plan and price, call nothing
#
# Run with:
#   Rscript R/05_extract/run_corpus.R --dry
#   Rscript R/05_extract/run_corpus.R --limit=10

root <- rprojroot::find_root(rprojroot::has_file("CC4A.Rproj"))
source(file.path(root, "R/00_shared/paths.R"))
source(file.path(root, "R/00_shared/utils.R"))
source(file.path(root, "R/05_extract/extract_verbatim.R"))

# TODO
# 1. build the work list: in scope, full text present, not already extracted
# 2. with --dry, measure the prompt size per record from the real page text
#    and print the expected cost, so a full run is never a surprise
# 3. otherwise call the extractor per record, catch every error so one bad
#    PDF does not stop the run, and write the error into the log
# 4. append results after every record, never at the end
# 5. print a summary: records done, rows extracted, rows dropped at
#    verification, errors
stop("not implemented yet")
