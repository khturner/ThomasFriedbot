# ThomasFriedbot

We'll use [Cristian Baldi's Docker images that wrap torch-rnn](https://github.com/crisbal/docker-torch-rnn) to do this training.

```
docker run --rm -ti -v /home/khturner/friedman:/root/torch-rnn/friedman crisbal/torch-rnn:base bash
git clone https://github.com/khturner/ThomasFriedbot.git

# Preprocess the training data
python scripts/preprocess.py \
--input_txt friedman/corpus.txt \
--output_h5 friedman/corpus.h5 \
--output_json friedman/corpus.json

# Train
th train.lua \
-input_h5 friedman/corpus.h5 \
-input_json friedman/corpus.json \
-gpu -1
```
