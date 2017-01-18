# ThomasFriedbot

## Collecting the corpus
- Burton DeWilde has done a bit of homework on scraping his NYT columns here: http://bdewilde.github.io/blog/blogger/2013/10/15/friedman-corpus-1-background-and-creation/
- TLF also apparently writes for RCP: http://www.realclearpolitics.com/authors/thomas_friedman/

```
docker run --rm -ti -v /home/khturner/friedman:/root/torch-rnn/friedman crisbal/torch-rnn:base bash
echo "deb http://cran.rstudio.com/bin/linux/ubuntu trusty/" >> /etc/apt/sources.list
gpg --keyserver keyserver.ubuntu.com --recv-key E084DAB9
gpg -a --export E084DAB9 | sudo apt-key add -
apt-get update
apt-get -y upgrade
apt-get -y install nano r-base libcurl4-openssl-dev libxml2-dev 

# Run in R to get set up for scraping scripts
install.packages("tidyverse")
install.packages("rtimes") # https://github.com/rOpenGov/rtimes

# Back in bash
git clone https://github.com/khturner/ThomasFriedbot.git
cd ThomasFriedbot
```

## Training
We'll use [Cristian Baldi's Docker images that wrap torch-rnn](https://github.com/crisbal/docker-torch-rnn) to do this training.

```
# Collect corpuses (corpi?) as you generate them
cd ~/torch-rnn
cat ThomasFriedbot/data/nyt_corpus.txt > friedman/corpus.txt

# Preprocess the training data
python scripts/preprocess.py \
--input_txt friedman/corpus.txt \
--output_h5 friedman/corpus.h5 \
--output_json friedman/corpus.json

# Train
th train.lua -num_layers 3 -rnn_size 256 -checkpoint_name friedman/checkpoint \
-input_h5 friedman/corpus.h5 \
-input_json friedman/corpus.json \
-gpu -1
```
