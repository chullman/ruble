# Use the sample method to grab a random word to use as the Wordle
# Ideally, there would be checks in place to ensure that the user won't get the same Wordle on subsequent playthroughs,
# but given that 'json_results' contains 5000+ possible words, this is unlikely to happen
def fetch_random_wordle(json_results)
    return json_results.sample
end