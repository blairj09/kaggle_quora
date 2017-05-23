################################################################################
########################### Quora Data Preprocessing ###########################
################################################################################

# Working directory (r project directory)

# Packages ----
require(data.table)
require(magrittr)
require(feather)
require(dplyr)

# Random seed ----
set.seed(35749)

# Original data ----
# Train
train <- fread("data/train.csv")

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
write_feather(tidy_train, "data/tidy_train.feather")
write_feather(train[,.(is_duplicate)], "data/train_responses.feather")

# Test data
write_feather(test, "data/test.feather")

# Combined data
write_feather(tidy_data, "data/tidy_data.feather")