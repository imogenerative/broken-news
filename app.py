import os

import feedparser
import codecs

from flask import Flask, render_template

broken_news = Flask(__name__)

@broken_news.before_first_request
def parse_feeds():
    # feedparser from http://code.google.com/p/feedparser/
    # open the feeds file and create source list
    file = open("./feeds.txt", "r")
    input = file.readlines()

    feedslist = []

    for item in input:
        feedslist.append(item.replace("\n", ""))

    file.close()

    headlines = []

    # parse the given RSS feeds
    for item in feedslist:
        feeds = feedparser.parse(item)

        # create list of headlines
        for i in range(len(feeds.entries)):
            headlines.append(feeds.entries[i].title)

    # write master file of headlines for frontend
    file = codecs.open("./static/master.txt", "w", encoding='utf8')

    for item in headlines:
        file.write(item + "\n")

    file.close()


@broken_news.route('/')
def news():
    return render_template("index.html")

if __name__ == "__main__":
    port = int(os.environ.get("PORT", 5000))
    broken_news.run(host="0.0.0.0", port=port)
