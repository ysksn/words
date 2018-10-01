full_path    = 'http://www.sccsc.jp/'
noun_factory = Factories::NounFactory.new(full_path: full_path)
noun_factory.register_nouns
Source.find_by(full_path: full_path).update(crawled_at: Time.current)
