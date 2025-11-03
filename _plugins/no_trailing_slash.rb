module Jekyll
  class NoTrailingSlashPermalinkGenerator < Generator
    safe true
    priority :highest

    def generate(site)
      # Process all pages to remove trailing slashes from permalinks
      site.pages.each do |page|
        if page.data['permalink'] && page.data['permalink'].end_with?('/')
          page.data['permalink'] = page.data['permalink'].chomp('/')
        end
      end
      
      # Process collections
      site.collections.each do |label, collection|
        collection.docs.each do |doc|
          if doc.data['permalink'] && doc.data['permalink'].end_with?('/')
            doc.data['permalink'] = doc.data['permalink'].chomp('/')
          end
        end
      end
    end
  end
  
  # Override the url method to ensure no trailing slashes
  module UrlNoTrailingSlash
    def url
      @url ||= URL.new({
        :template => template,
        :placeholders => url_placeholders,
        :permalink => permalink
      }).to_s.chomp('/')
    end
  end
  
  class Page
    prepend UrlNoTrailingSlash
  end
  
  class Document
    prepend UrlNoTrailingSlash
  end
end

