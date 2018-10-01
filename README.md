# README

This is a rails app using GraphQL to query and mutate resources.

# Install
`git clone git@github.com:ysksn/words.git`

`bundle install`

`bundle exec rails db:setup`

# Usage

`bundle exec rails s`

Open a browser and go to [localhost](http://localhost:3000/graphiql/).

### Query
Please pass a `fullPath` of URL as an argument where you want to retrieve words of paragraphs.

| key | value | type | required? |
| --- | --- | ---| --- |
| `fullPath` | URL | `String` | `true` |
| `order` | (`"desc"`\|`"asc"`) | `String` | `false` |
| `limit` | num of words | `Int` | `false` |
_(`limit` cannot exceed 100.)_

```ruby
{
  words(fullPath: "http://www.sccsc.jp/", order: "desc", limit: 5) {
    word
    count
  }
}
```

_result_

```json
{
  "data": {
    "words": [
      {
        "word": "訓練",
        "count": 8
      },
      {
        "word": "者",
        "count": 8
      },
      {
        "word": "職業",
        "count": 5
      },
      {
        "word": "方",
        "count": 5
      },
      {
        "word": "ハロー",
        "count": 4
      }
    ]
  }
}
```

### Mutation

```
mutation crawlWords($input: CrawlWordsInput!) {
  crawlWords(input: $input) {
    source {
      fullPath
      crawledAt
    }
    errors
  }
}
```

#### query variables

Please pass a `fullPath` of URL as an argument where you want to crawl words of paragraphs.

| key | value | type | required? |
| --- | --- | ---| --- |
| `fullPath` | URL | `String` | `true` |

```json
{
  "input": {
    "fullPath": "http://www.sccsc.jp/"
  }
}
```

_result_

```json
{
  "data": {
    "crawlWords": {
      "source": {
        "fullPath": "http://www.sccsc.jp/",
        "crawledAt": "2018-10-01 18:02:17 +0900"
      },
      "errors": []
    }
  }
}
```

# Test

`bundle exec rspec`