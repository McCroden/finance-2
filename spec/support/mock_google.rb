def mock_google(symbol)
  resp = fixture("#{symbol}.xml").read
  FakeWeb.register_uri(:get,
                       "http://www.google.com/ig/api?stock=#{symbol}",
                       body: resp,
                       content_length: resp.length,
                       content_type: 'text/xml')
end
