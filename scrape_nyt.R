library(tidyverse)
library(rtimes)
Sys.setenv(NYTIMES_AS_KEY = "ce3ec3e38ab64507a001b547319d18a8")

# Collect TLF URLs
urls <- c()
end_of_results <- F
p <- -1
while(!end_of_results) {
  p <- p + 1
  print(p)
  tryCatch({
    Sys.sleep(1) # Avoid the too many calls limit
    x <- as_search(q = "THOMAS FRIEDMAN", fq = "type_of_material: (\"Op-Ed\")", page = p)
    urls <- c(urls, sapply(x$data, function(x) {x$web_url} ))
  },
  http_403 = function(c) { print("Hit a 403"); print(c); end_of_results <- F }, # The API randomly chokes on some pages. Thanks, Obama.
  http_400 = function(c) { print("Hit a 400"); print(c); end_of_results <- T }) # Well this doesn't actually break out of the loop. CTRL-C out when done
}

# Collect inanity
tlf_paragraphs <- c()
for (url in urls) {
  story <- read_html(url) %>% html_nodes(".story-body-text") %>% html_text
  tlf_paragraphs <- c(tlf_paragraphs, story)
}

# Save it
writeLines(tlf_paragraphs, "/root/torch-rnn/friedman/corpus.txt")
