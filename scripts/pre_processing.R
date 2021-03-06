################################################################################
########################### Quora Data Preprocessing ###########################
################################################################################

# Working directory (r project directory)

# Packages ----
require(data.table)
require(magrittr)
require(feather)
require(dplyr)
require(tidytext)

# Random seed ----
set.seed(35749)

# Original data ----
# Train
train <- fread("data/train.csv")
train_lemma <- fread("data/train_lemmatized.csv")
# Test
test <- fread("data/test.csv")

# Create a sample of test data
test_sample <- test[sample(1:.N, 100000)]

# Tidy text ----
# Train
tidy_train <- train[,.(id, question1, question2)] %>% 
  melt(id.var = "id", value = "question", variable = "question_num") %>% 
  unnest_tokens(word, question) %>% 
  mutate(data = "train") %>% 
  as.data.table

tidy_train_lemma_ds <- train_lemma[,.(id, is_duplicate, question1_lemmas_destopped, question2_lemmas_destopped)] %>% 
  melt(id.var = c("id", "is_duplicate"), value = "question", variable = "question_num") %>% 
  unnest_tokens(word, question) %>% 
  mutate(data = "train_lemma") %>% 
  as.data.table

# Train ngrams
tidy_train_bigrams <- train[,.(id, question1, question2, is_duplicate)] %>% 
  melt(id.var = c("id", "is_duplicate"), value = "question", variable = "question_num") %>% 
  unnest_tokens(bigram, question, token = "ngrams", n = 2) %>% 
  as.data.table

tidy_train_lemma_bigrams <- train_lemma[,.(id, question1_lemmas_destopped, question2_lemmas_destopped, is_duplicate)] %>% 
  melt(id.var = c("id", "is_duplicate"), value = "question", variable = "question_num") %>% 
  unnest_tokens(bigram, question, token = "ngrams", n = 2) %>% 
  as.data.table

# Test sample
tidy_test_sample <- test_sample[,.(test_id, question1, question2)] %>% 
  melt(id.var = "test_id", value = "question", variable = "question_num") %>%
  unnest_tokens(word, question) %>%
  mutate(data = "test_sample", id = paste0("test_", test_id)) %>%
  select(-test_id) %>% 
  as.data.table

# Combined data
tidy_data <- rbind(tidy_train, tidy_test_sample)

# Feather ----
# Train data
write_feather(train, "data/train.feather")
write_feather(train_lemma, "data/train_lemma.feather")
write_feather(tidy_train, "data/tidy_train.feather")
write_feather(tidy_train_lemma_ds, "data/tidy_train_lemmas.feather")
write_feather(tidy_train_lemma_bigrams, "data/tidy_train_lemmas_bigrams.feather")
write_feather(train[,.(is_duplicate)], "data/train_responses.feather")

# Test data
write_feather(test, "data/test.feather")

# Combined data
write_feather(tidy_data, "data/tidy_data.feather")