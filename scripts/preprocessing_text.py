import pandas as pd
import nltk
from nltk import word_tokenize
from nltk.stem.wordnet import WordNetLemmatizer
from nltk.corpus import wordnet


# Configure lemmatizer
# nltk uses treebank tags. WNLemmatizer uses ADJ, ADJ_SAT, ADV, NOUN, VERB = 'a', 's', 'r', 'n', 'v'
# use get_wordnet_pos to convert treebank tags to wordnet tags before lemmatizing
lemmatizer = WordNetLemmatizer()


def get_wordnet_pos(treebank_tag):

    if treebank_tag.startswith('J'):
        return wordnet.ADJ
    elif treebank_tag.startswith('V'):
        return wordnet.VERB
    elif treebank_tag.startswith('N'):
        return wordnet.NOUN
    elif treebank_tag.startswith('R'):
        return wordnet.ADV
    else:
        return 'n'


df = pd.read_csv('../data/train.csv', index_col="id")

def tokenize_lower(question_col_raw):
    tokenized_questions =  [word_tokenize(q) for q in question_col_raw]
    return tokenized_questions


tokenized_questions_list = tokenize_lower(df.question1)
print(t[:5])